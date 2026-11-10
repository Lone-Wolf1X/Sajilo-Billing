package com.saisa.app.license;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.admin.email.EmailService;
import com.saisa.app.license.dto.ActivateLicenseRequest;
import com.saisa.app.license.dto.GenerateLicenseRequest;
import com.saisa.app.license.dto.GeneratedLicenseResponse;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Base64;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/licenses")
public class LicenseController {

    private final LicenseSignerService signerService;
    private final LicenseVerifierService verifierService;
    private final EmailService emailService;
    private final ObjectMapper objectMapper;

    public LicenseController(
            LicenseSignerService signerService,
            LicenseVerifierService verifierService,
            EmailService emailService,
            ObjectMapper objectMapper
    ) {
        this.signerService = signerService;
        this.verifierService = verifierService;
        this.emailService = emailService;
        this.objectMapper = objectMapper;
    }

    @GetMapping("/public-key")
    public ResponseEntity<Map<String, String>> getPublicKey() {
        return ResponseEntity.ok(Map.of(
                "algorithm", "RSA-2048 / SHA256withRSA",
                "publicKeyBase64", LicenseKeyProvider.PUBLIC_KEY_BASE64
        ));
    }

    @GetMapping("/status")
    public ResponseEntity<LicenseStatusResponse> getLicenseStatus() {
        Long tenantId = TenantContext.getOptionalTenantId().orElse(1L);
        return ResponseEntity.ok(verifierService.getStatus(tenantId, "Tenant-" + tenantId));
    }

    @PostMapping("/activate")
    @PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN')")
    public ResponseEntity<LicenseStatusResponse> activateLicense(@RequestBody ActivateLicenseRequest req) {
        Long tenantId = TenantContext.getOptionalTenantId().orElse(1L);

        LicenseContainer container;
        try {
            if (req.zipBase64() != null && !req.zipBase64().isBlank()) {
                byte[] zipBytes = Base64.getDecoder().decode(req.zipBase64());
                container = verifierService.extractFromEncryptedZip(zipBytes, req.zipPassword());
            } else if (req.licenseJson() != null && !req.licenseJson().isBlank()) {
                container = objectMapper.readValue(req.licenseJson(), LicenseContainer.class);
            } else {
                throw new IllegalArgumentException("Either zipBase64 with zipPassword or licenseJson is required.");
            }

            LicenseStatusResponse activated = verifierService.activateLicense(tenantId, container);
            return ResponseEntity.ok(activated);
        } catch (Exception e) {
            throw new RuntimeException("License activation failed: " + e.getMessage(), e);
        }
    }

    @PostMapping("/generate")
    @PreAuthorize("hasRole('PLATFORM_ADMIN')")
    public ResponseEntity<GeneratedLicenseResponse> generateLicense(@Valid @RequestBody GenerateLicenseRequest req) {
        LicenseContainer container = signerService.generateLicense(
                req.tenantCode(),
                req.companyName(),
                req.panNumber(),
                req.plan() != null ? req.plan() : LicensePlan.GROWTH,
                req.durationDays() > 0 ? req.durationDays() : 365,
                req.maxUsers() > 0 ? req.maxUsers() : 5,
                req.allowedFeatures()
        );

        byte[] encryptedZipBytes = signerService.createEncryptedZipPackage(container, req.zipPassword());
        String zipBase64 = Base64.getEncoder().encodeToString(encryptedZipBytes);
        String filename = "license_" + req.tenantCode().toLowerCase() + ".zip";

        boolean emailed = false;
        if (req.deliveryEmail() != null && !req.deliveryEmail().isBlank()) {
            try {
                String subject = "Official Sajilo Billing License Package - " + req.companyName();
                String body = """
                        Dear %s,
                        
                        Thank you for choosing Sajilo Billing (SAISA Accounting Engine).
                        
                        Attached is your official encrypted commercial license package:
                        - File: %s
                        - License ID: %s
                        - Plan: %s
                        - Expiry: %s
                        - Unpack Password: %s
                        
                        Please upload this ZIP file in Sajilo Billing -> Admin Settings -> License & Subscription.
                        
                        Best regards,
                        NextGen Innovations (Sajilo Billing)
                        """.formatted(
                        req.companyName(),
                        filename,
                        container.payload().licenseId(),
                        container.payload().plan(),
                        container.payload().expiresAt(),
                        req.zipPassword()
                );
                emailService.sendEmail(req.deliveryEmail(), subject, body);
                emailed = true;
            } catch (Exception e) {
                emailed = false;
            }
        }

        return ResponseEntity.ok(new GeneratedLicenseResponse(
                container,
                zipBase64,
                filename,
                req.zipPassword(),
                emailed
        ));
    }
}
