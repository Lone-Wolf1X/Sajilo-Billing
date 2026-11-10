package com.saisa.app.license;

import com.fasterxml.jackson.databind.ObjectMapper;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.FileHeader;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.security.Signature;
import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import java.util.Optional;

@Service
public class LicenseVerifierService {

    private final LicenseKeyProvider keyProvider;
    private final TenantLicenseRepository licenseRepository;
    private final ObjectMapper objectMapper;

    public LicenseVerifierService(
            LicenseKeyProvider keyProvider,
            TenantLicenseRepository licenseRepository,
            ObjectMapper objectMapper
    ) {
        this.keyProvider = keyProvider;
        this.licenseRepository = licenseRepository;
        this.objectMapper = objectMapper;
    }

    public LicenseContainer extractFromEncryptedZip(byte[] zipBytes, String password) {
        File tempZip = null;
        try {
            tempZip = File.createTempFile("uploaded_lic_", ".zip");
            Files.write(tempZip.toPath(), zipBytes);

            ZipFile zipFile = new ZipFile(tempZip, password != null ? password.toCharArray() : null);
            if (!zipFile.isValidZipFile()) {
                throw new IllegalArgumentException("The uploaded file is not a valid ZIP file.");
            }

            FileHeader header = zipFile.getFileHeader("license.json");
            if (header == null) {
                throw new IllegalArgumentException("Uploaded ZIP does not contain 'license.json'.");
            }

            try (InputStream is = zipFile.getInputStream(header)) {
                byte[] jsonBytes = is.readAllBytes();
                return objectMapper.readValue(jsonBytes, LicenseContainer.class);
            }
        } catch (Exception e) {
            throw new IllegalArgumentException("Failed to unpack encrypted license ZIP. Incorrect password or invalid file: " + e.getMessage(), e);
        } finally {
            if (tempZip != null && tempZip.exists()) {
                tempZip.delete();
            }
        }
    }

    public void verifySignature(LicenseContainer container) {
        try {
            byte[] payloadBytes = objectMapper.writeValueAsBytes(container.payload());
            Signature signature = Signature.getInstance(container.algorithm() != null ? container.algorithm() : "SHA256withRSA");
            signature.initVerify(keyProvider.getPublicKey());
            signature.update(payloadBytes);

            byte[] sigBytes = Base64.getDecoder().decode(container.signature());
            boolean valid = signature.verify(sigBytes);
            if (!valid) {
                throw new SecurityException("Cryptographic verification failed: RSA digital signature is invalid. The license file has been modified or tampered with.");
            }
        } catch (SecurityException se) {
            throw se;
        } catch (Exception e) {
            throw new SecurityException("Signature verification error: " + e.getMessage(), e);
        }
    }

    @Transactional
    public LicenseStatusResponse activateLicense(Long tenantId, LicenseContainer container) {
        // 1. Cryptographic signature check
        verifySignature(container);

        LicensePayload payload = container.payload();
        Instant now = Instant.now();

        // 2. Expiry check
        if (payload.expiresAt().isBefore(now)) {
            throw new IllegalArgumentException("Cannot activate expired license! Expiry date was " + payload.expiresAt());
        }

        // 3. Deactivate previous active licenses for this tenant
        licenseRepository.findFirstByTenantIdAndActiveTrueOrderByExpiresAtDesc(tenantId)
                .ifPresent(prev -> {
                    prev.setActive(false);
                    prev.setUpdatedAt(now);
                    licenseRepository.save(prev);
                });

        // 4. Save new active license
        TenantLicense entity = new TenantLicense();
        entity.setTenantId(tenantId);
        entity.setLicenseId(payload.licenseId());
        entity.setPlan(payload.plan().name());
        entity.setMaxUsers(payload.maxUsers());
        entity.setAllowedFeatures(String.join(",", payload.allowedFeatures()));
        entity.setIssuedAt(payload.issuedAt());
        entity.setExpiresAt(payload.expiresAt());
        try {
            entity.setRawPayload(objectMapper.writeValueAsString(payload));
        } catch (Exception e) {
            entity.setRawPayload("{}");
        }
        entity.setSignature(container.signature());
        entity.setActive(true);
        entity.setCreatedAt(now);
        entity.setUpdatedAt(now);

        licenseRepository.save(entity);

        long daysRemaining = Math.max(0, Duration.between(now, payload.expiresAt()).toDays());

        return new LicenseStatusResponse(
                true,
                payload.plan() == LicensePlan.TRIAL,
                payload.plan().name(),
                payload.licenseId(),
                payload.companyName(),
                payload.panNumber(),
                payload.issuedAt(),
                payload.expiresAt(),
                daysRemaining,
                payload.maxUsers(),
                payload.allowedFeatures(),
                false
        );
    }

    public LicenseStatusResponse getStatus(Long tenantId, String tenantCode) {
        Optional<TenantLicense> activeOpt = licenseRepository.findFirstByTenantIdAndActiveTrueOrderByExpiresAtDesc(tenantId);
        Instant now = Instant.now();

        if (activeOpt.isPresent()) {
            TenantLicense lic = activeOpt.get();
            boolean expired = lic.getExpiresAt().isBefore(now);
            long daysRemaining = expired ? 0 : Duration.between(now, lic.getExpiresAt()).toDays();
            List<String> features = Arrays.asList(lic.getAllowedFeatures().split(","));

            return new LicenseStatusResponse(
                    !expired,
                    "TRIAL".equalsIgnoreCase(lic.getPlan()),
                    lic.getPlan(),
                    lic.getLicenseId(),
                    tenantCode,
                    "",
                    lic.getIssuedAt(),
                    lic.getExpiresAt(),
                    daysRemaining,
                    lic.getMaxUsers(),
                    features,
                    expired
            );
        }

        // Default: 30-Day Evaluation Trial
        Instant trialStart = now.minus(5, java.time.temporal.ChronoUnit.DAYS);
        Instant trialEnd = trialStart.plus(30, java.time.temporal.ChronoUnit.DAYS);
        long daysRemaining = Duration.between(now, trialEnd).toDays();

        return new LicenseStatusResponse(
                true,
                true,
                "TRIAL",
                "TRIAL-EVAL-30D",
                tenantCode != null ? tenantCode : "Retail Shop",
                "",
                trialStart,
                trialEnd,
                Math.max(0, daysRemaining),
                2,
                LicenseSignerService.defaultFeaturesForPlan(LicensePlan.TRIAL),
                daysRemaining <= 0
        );
    }
}
