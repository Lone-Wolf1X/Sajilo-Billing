package com.saisa.app.setup;

import com.saisa.common.tenant.TenantContext;
import com.saisa.common.tenant.dto.CompanyProfileResponse;
import com.saisa.common.tenant.dto.OpeningBalanceRequest;
import com.saisa.common.tenant.dto.OpeningBalanceResponse;
import com.saisa.common.tenant.dto.OpeningStockRequest;
import com.saisa.common.tenant.dto.OpeningStockResponse;
import com.saisa.common.tenant.dto.SetupStatusResponse;
import com.saisa.common.tenant.dto.UpdateProfileRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/setup")
@PreAuthorize("hasRole('PLATFORM_ADMIN')")
public class SetupController {

    private final ProfileSetupService setupService;
    private final OpeningBalanceService openingBalanceService;
    private final OpeningStockService openingStockService;

    public SetupController(ProfileSetupService setupService,
                           OpeningBalanceService openingBalanceService,
                           OpeningStockService openingStockService) {
        this.setupService = setupService;
        this.openingBalanceService = openingBalanceService;
        this.openingStockService = openingStockService;
    }

    @GetMapping("/profile")
    public ResponseEntity<CompanyProfileResponse> getProfile() {
        return ResponseEntity.ok(setupService.getProfile());
    }

    @PutMapping("/profile")
    public ResponseEntity<CompanyProfileResponse> updateProfile(@Valid @RequestBody UpdateProfileRequest req) {
        return ResponseEntity.ok(setupService.updateProfile(req));
    }

    @GetMapping("/status")
    public ResponseEntity<SetupStatusResponse> getStatus() {
        return ResponseEntity.ok(setupService.getStatus());
    }

    @PostMapping("/complete")
    public ResponseEntity<SetupStatusResponse> completeSetup() {
        return ResponseEntity.ok(setupService.completeSetup());
    }

    @GetMapping(value = "/locations", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> getLocations() {
        return ResponseEntity.ok(setupService.getLocationsJson());
    }

    @GetMapping(value = "/registration-authorities", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> getRegistrationAuthorities() {
        return ResponseEntity.ok(setupService.getRegistrationAuthoritiesJson());
    }

    @GetMapping("/opening-balances")
    public ResponseEntity<OpeningBalanceResponse> getOpeningBalances() {
        Long tenantId = TenantContext.getCurrentTenantId();
        return ResponseEntity.ok(openingBalanceService.getCurrent(tenantId));
    }

    @PostMapping("/opening-balances")
    public ResponseEntity<OpeningBalanceResponse> postOpeningBalances(
            @Valid @RequestBody OpeningBalanceRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(openingBalanceService.post(tenantId, req, userId));
    }

    @DeleteMapping("/opening-balances")
    public ResponseEntity<Void> resetOpeningBalances(
            @RequestParam(required = false, defaultValue = "Reset opening balances") String reason) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();
        openingBalanceService.resetViaReversal(tenantId, userId, reason);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/opening-stock")
    public ResponseEntity<OpeningStockResponse> getOpeningStock() {
        Long tenantId = TenantContext.getCurrentTenantId();
        return ResponseEntity.ok(openingStockService.getCurrent(tenantId));
    }

    @PostMapping("/opening-stock")
    public ResponseEntity<OpeningStockResponse> postOpeningStock(
            @Valid @RequestBody OpeningStockRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(openingStockService.post(tenantId, req, userId));
    }
}
