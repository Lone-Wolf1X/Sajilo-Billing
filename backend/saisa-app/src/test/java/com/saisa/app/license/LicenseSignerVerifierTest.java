package com.saisa.app.license;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

class LicenseSignerVerifierTest {

    private LicenseSignerService signerService;
    private LicenseVerifierService verifierService;
    private TenantLicenseRepository licenseRepository;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        LicenseKeyProvider keyProvider = new LicenseKeyProvider();
        signerService = new LicenseSignerService(keyProvider, objectMapper);

        licenseRepository = Mockito.mock(TenantLicenseRepository.class);
        when(licenseRepository.findFirstByTenantIdAndActiveTrueOrderByExpiresAtDesc(any()))
                .thenReturn(Optional.empty());

        verifierService = new LicenseVerifierService(keyProvider, licenseRepository, objectMapper);
    }

    @Test
    void shouldGenerateSignAndVerifyLicenseSuccessfully() {
        LicenseContainer container = signerService.generateLicense(
                "nepalretail",
                "Nepal Retail Mart Pvt. Ltd.",
                "304958291",
                LicensePlan.ENTERPRISE,
                365,
                10,
                List.of("POS", "DOUBLE_ENTRY", "REPORTS", "IRD_TAX", "SMTP_EMAIL", "MULTI_USER")
        );

        assertNotNull(container);
        assertNotNull(container.signature());
        assertEquals("nepalretail", container.payload().tenantCode());

        // Verifier must succeed without exception
        assertDoesNotThrow(() -> verifierService.verifySignature(container));
    }

    @Test
    void shouldRejectTamperedLicenseSignature() {
        LicenseContainer container = signerService.generateLicense(
                "nepalretail",
                "Nepal Retail Mart Pvt. Ltd.",
                "304958291",
                LicensePlan.ENTERPRISE,
                365,
                10,
                List.of("POS", "DOUBLE_ENTRY")
        );

        // Tamper signature
        LicenseContainer tampered = new LicenseContainer(
                container.payload(),
                container.signature().substring(0, container.signature().length() - 4) + "AAAA",
                container.algorithm()
        );

        assertThrows(SecurityException.class, () -> verifierService.verifySignature(tampered));
    }

    @Test
    void shouldPackageAndExtractEncryptedZipSuccessfully() {
        String password = "StrongSecretPassword#2026";
        LicenseContainer container = signerService.generateLicense(
                "nepalretail",
                "Nepal Retail Mart Pvt. Ltd.",
                "304958291",
                LicensePlan.GROWTH,
                30,
                5,
                List.of("POS", "REPORTS")
        );

        byte[] zipBytes = signerService.createEncryptedZipPackage(container, password);
        assertNotNull(zipBytes);
        assertTrue(zipBytes.length > 100);

        // Correct password -> extracts correctly
        LicenseContainer extracted = verifierService.extractFromEncryptedZip(zipBytes, password);
        assertEquals(container.payload().licenseId(), extracted.payload().licenseId());
        assertEquals(container.payload().plan(), extracted.payload().plan());

        // Wrong password -> throws IllegalArgumentException
        assertThrows(IllegalArgumentException.class, () ->
                verifierService.extractFromEncryptedZip(zipBytes, "WrongPassword123")
        );
    }
}

