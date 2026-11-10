package com.saisa.app.license;

import com.fasterxml.jackson.databind.ObjectMapper;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.model.enums.AesKeyStrength;
import net.lingala.zip4j.model.enums.EncryptionMethod;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.security.Signature;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.List;
import java.util.UUID;

@Service
public class LicenseSignerService {

    private final LicenseKeyProvider keyProvider;
    private final ObjectMapper objectMapper;

    public LicenseSignerService(LicenseKeyProvider keyProvider, ObjectMapper objectMapper) {
        this.keyProvider = keyProvider;
        this.objectMapper = objectMapper;
    }

    public LicenseContainer generateLicense(
            String tenantCode,
            String companyName,
            String panNumber,
            LicensePlan plan,
            int durationDays,
            int maxUsers,
            List<String> allowedFeatures
    ) {
        try {
            Instant now = Instant.now();
            Instant expiresAt = now.plus(durationDays, ChronoUnit.DAYS);
            String licenseId = "LIC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            LicensePayload payload = new LicensePayload(
                    licenseId,
                    tenantCode,
                    companyName,
                    panNumber,
                    plan,
                    now,
                    expiresAt,
                    maxUsers,
                    allowedFeatures != null ? allowedFeatures : defaultFeaturesForPlan(plan)
            );

            // Canonical JSON string for signature
            byte[] payloadBytes = objectMapper.writeValueAsBytes(payload);

            Signature signature = Signature.getInstance("SHA256withRSA");
            signature.initSign(keyProvider.getPrivateKey());
            signature.update(payloadBytes);
            String signatureBase64 = Base64.getEncoder().encodeToString(signature.sign());

            return new LicenseContainer(payload, signatureBase64, "SHA256withRSA");
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate and sign license: " + e.getMessage(), e);
        }
    }

    public byte[] createEncryptedZipPackage(LicenseContainer container, String zipPassword) {
        File tempZip = null;
        try {
            tempZip = File.createTempFile("saisa_license_", ".zip");
            tempZip.delete(); // zip4j expects to create it

            ZipFile zipFile = new ZipFile(tempZip, zipPassword.toCharArray());

            // 1. Add license.json
            ZipParameters licenseParams = new ZipParameters();
            licenseParams.setEncryptFiles(true);
            licenseParams.setEncryptionMethod(EncryptionMethod.AES);
            licenseParams.setAesKeyStrength(AesKeyStrength.KEY_STRENGTH_256);
            licenseParams.setFileNameInZip("license.json");

            byte[] licenseJsonBytes = objectMapper.writerWithDefaultPrettyPrinter()
                    .writeValueAsBytes(container);
            zipFile.addStream(new ByteArrayInputStream(licenseJsonBytes), licenseParams);

            // 2. Add customer README.txt
            ZipParameters readmeParams = new ZipParameters();
            readmeParams.setEncryptFiles(true);
            readmeParams.setEncryptionMethod(EncryptionMethod.AES);
            readmeParams.setAesKeyStrength(AesKeyStrength.KEY_STRENGTH_256);
            readmeParams.setFileNameInZip("SAISA_LICENSE_README.txt");

            String readmeContent = """
                    =====================================================
                    SAISA / SAJILO BILLING - OFFICIAL COMMERCIAL LICENSE
                    =====================================================
                    License ID: %s
                    Tenant Code: %s
                    Company: %s
                    PAN: %s
                    Plan: %s
                    Valid Until: %s
                    Max Users: %d
                    
                    INSTRUCTIONS:
                    1. Keep this ZIP file secure.
                    2. In Sajilo Billing App, go to Admin Settings -> License & Subscription.
                    3. Click 'Upload License ZIP', select this file, and enter your password.
                    4. Your license and features will be unlocked immediately.
                    
                    Support: nextgeninnovationsprivatelimit@gmail.com
                    =====================================================
                    """.formatted(
                    container.payload().licenseId(),
                    container.payload().tenantCode(),
                    container.payload().companyName(),
                    container.payload().panNumber(),
                    container.payload().plan(),
                    container.payload().expiresAt(),
                    container.payload().maxUsers()
            );

            zipFile.addStream(new ByteArrayInputStream(readmeContent.getBytes(StandardCharsets.UTF_8)), readmeParams);

            byte[] zipBytes = Files.readAllBytes(tempZip.toPath());
            return zipBytes;
        } catch (Exception e) {
            throw new RuntimeException("Failed to package encrypted license ZIP: " + e.getMessage(), e);
        } finally {
            if (tempZip != null && tempZip.exists()) {
                tempZip.delete();
            }
        }
    }

    public static List<String> defaultFeaturesForPlan(LicensePlan plan) {
        return switch (plan) {
            case TRIAL -> List.of("POS", "DOUBLE_ENTRY", "REPORTS", "IRD_TAX", "SMTP_EMAIL", "MULTI_USER");
            case STARTER -> List.of("POS", "DOUBLE_ENTRY", "INVENTORY");
            case GROWTH -> List.of("POS", "DOUBLE_ENTRY", "INVENTORY", "REPORTS", "IRD_TAX", "SMTP_EMAIL");
            case ENTERPRISE -> List.of("POS", "DOUBLE_ENTRY", "INVENTORY", "REPORTS", "IRD_TAX", "SMTP_EMAIL", "MULTI_USER", "BACKUP_RESTORE");
        };
    }
}
