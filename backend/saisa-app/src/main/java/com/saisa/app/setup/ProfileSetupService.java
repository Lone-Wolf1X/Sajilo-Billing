package com.saisa.app.setup;

import com.saisa.common.audit.AuditLogService;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantContext;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.tenant.dto.CompanyProfileResponse;
import com.saisa.common.tenant.dto.SetupStatusResponse;
import com.saisa.common.tenant.dto.UpdateProfileRequest;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Map;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class ProfileSetupService {

    private final TenantRepository tenantRepo;
    private final AuditLogService auditLog;
    private String cachedLocations;
    private String cachedAuthorities;

    public ProfileSetupService(TenantRepository tenantRepo, AuditLogService auditLog) {
        this.tenantRepo = tenantRepo;
        this.auditLog = auditLog;
    }

    @Transactional(readOnly = true)
    public CompanyProfileResponse getProfile() {
        Long tenantId = TenantContext.getCurrentTenantId();
        Tenant tenant = tenantRepo.findById(tenantId)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tenant not found"));
        return CompanyProfileResponse.from(tenant);
    }

    @Transactional(readOnly = true)
    public SetupStatusResponse getStatus() {
        Long tenantId = TenantContext.getCurrentTenantId();
        Tenant tenant = tenantRepo.findById(tenantId)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tenant not found"));
        return SetupStatusResponse.from(tenant);
    }

    @Transactional
    public CompanyProfileResponse updateProfile(UpdateProfileRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Tenant tenant = tenantRepo.findById(tenantId)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tenant not found"));

        tenant.setCompanyName(req.companyName());
        tenant.setCompanyNameNepali(req.companyNameNepali());
        if (req.legalName() != null) {
            tenant.setLegalName(req.legalName());
        }
        tenant.setPanVatNo(req.panVatNo());
        if (req.panVatNo() != null && !req.panVatNo().isBlank()) {
            tenant.setPan(req.panVatNo());
        }
        tenant.setPanVatDate(req.panVatDate());
        tenant.setRegistrationAuthority(req.registrationAuthority());
        tenant.setRegistrationNo(req.registrationNo());
        tenant.setRegistrationDate(req.registrationDate());
        tenant.setProvince(req.province());
        tenant.setDistrict(req.district());
        tenant.setMunicipalityVdc(req.municipalityVdc());
        tenant.setWardNo(req.wardNo());
        tenant.setToleStreet(req.toleStreet());

        if (req.address() != null && !req.address().isBlank()) {
            tenant.setAddress(req.address());
        } else if (req.toleStreet() != null || req.municipalityVdc() != null) {
            StringBuilder sb = new StringBuilder();
            if (req.toleStreet() != null && !req.toleStreet().isBlank()) {
                sb.append(req.toleStreet());
            }
            if (req.wardNo() != null) {
                if (!sb.isEmpty()) sb.append(", ");
                sb.append("Ward-").append(req.wardNo());
            }
            if (req.municipalityVdc() != null && !req.municipalityVdc().isBlank()) {
                if (!sb.isEmpty()) sb.append(", ");
                sb.append(req.municipalityVdc());
            }
            if (req.district() != null && !req.district().isBlank()) {
                if (!sb.isEmpty()) sb.append(", ");
                sb.append(req.district());
            }
            tenant.setAddress(sb.toString());
        }

        if (req.phone() != null) tenant.setPhone(req.phone());
        if (req.email() != null) tenant.setEmail(req.email());
        if (req.incorporationType() != null) tenant.setIncorporationType(req.incorporationType());
        if (req.businessNature() != null) tenant.setBusinessNature(req.businessNature());
        tenant.setAuthorizedPersonName(req.authorizedPersonName());
        tenant.setAuthorizedPersonDesignation(req.authorizedPersonDesignation());
        tenant.setAuthorizedPersonPhone(req.authorizedPersonPhone());
        tenant.setAuthorizedPersonEmail(req.authorizedPersonEmail());

        if (req.setupStep() != null && req.setupStep() > tenant.getSetupStep()) {
            tenant.setSetupStep(Math.min(4, req.setupStep()));
        }

        Tenant saved = tenantRepo.save(tenant);
        auditLog.record("UPDATE_PROFILE", "Tenant", saved.getId(), "SUCCESS",
            Map.of("companyName", saved.getCompanyName()), 0L);
        return CompanyProfileResponse.from(saved);
    }

    @Transactional
    public SetupStatusResponse completeSetup() {
        Long tenantId = TenantContext.getCurrentTenantId();
        Tenant tenant = tenantRepo.findById(tenantId)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Tenant not found"));

        tenant.setSetupCompleted(true);
        tenant.setSetupCompletedAt(Instant.now());
        tenant.setSetupStep(4);
        Tenant saved = tenantRepo.save(tenant);
        auditLog.record("COMPLETE_SETUP", "Tenant", saved.getId(), "SUCCESS",
            Map.of("tenantCode", saved.getTenantCode()), 0L);
        return SetupStatusResponse.from(saved);
    }

    public synchronized String getLocationsJson() {
        if (cachedLocations == null) {
            cachedLocations = readResource("static/data/locations_unified.json");
        }
        return cachedLocations;
    }

    public synchronized String getRegistrationAuthoritiesJson() {
        if (cachedAuthorities == null) {
            cachedAuthorities = readResource("static/data/registration_authorities.json");
        }
        return cachedAuthorities;
    }

    private String readResource(String path) {
        try {
            ClassPathResource res = new ClassPathResource(path);
            try (InputStream is = res.getInputStream()) {
                return new String(is.readAllBytes(), StandardCharsets.UTF_8);
            }
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Failed to load resource: " + path, e);
        }
    }
}

