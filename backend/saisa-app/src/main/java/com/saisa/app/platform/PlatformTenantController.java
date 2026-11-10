package com.saisa.app.platform;

import com.saisa.app.license.LicenseStatusResponse;
import com.saisa.app.platform.dto.CreateTenantRequest;
import com.saisa.app.platform.dto.CreateTenantResponse;
import com.saisa.app.platform.dto.InjectLicenseRequest;
import com.saisa.app.platform.dto.TenantSummaryResponse;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/platform")
@PreAuthorize("hasRole('PLATFORM_ADMIN')")
public class PlatformTenantController {

    private final PlatformTenantService service;

    public PlatformTenantController(PlatformTenantService service) {
        this.service = service;
    }

    @GetMapping("/tenants")
    public List<TenantSummaryResponse> list() {
        return service.listTenants();
    }

    @PostMapping("/tenants")
    public ResponseEntity<CreateTenantResponse> create(@Valid @RequestBody CreateTenantRequest req) {
        Long currentUserId = TenantContext.getCurrentUserId();
        CreateTenantResponse resp = service.createTenant(req, currentUserId);
        return ResponseEntity.status(HttpStatus.CREATED).body(resp);
    }

    @PostMapping("/tenants/{id}/inject-license")
    public ResponseEntity<LicenseStatusResponse> injectLicense(
            @PathVariable Long id,
            @Valid @RequestBody InjectLicenseRequest req) {
        LicenseStatusResponse resp = service.injectLicense(id, req);
        return ResponseEntity.ok(resp);
    }

    @GetMapping("/demo-leads")
    public List<DemoLead> listDemoLeads() {
        return service.listDemoLeads();
    }

    @PutMapping("/demo-leads/{id}/status")
    public ResponseEntity<DemoLead> updateDemoLeadStatus(
            @PathVariable Long id,
            @RequestParam String status) {
        return ResponseEntity.ok(service.updateDemoLeadStatus(id, status));
    }
}
