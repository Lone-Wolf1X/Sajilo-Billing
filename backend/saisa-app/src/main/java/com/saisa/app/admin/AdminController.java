package com.saisa.app.admin;

import com.saisa.app.admin.dto.AdminUserResponse;
import com.saisa.app.admin.dto.CreateUserRequest;
import com.saisa.app.admin.dto.OnboardTenantRequest;
import com.saisa.app.admin.dto.ResetPasswordRequest;
import com.saisa.app.admin.dto.TenantSummaryResponse;
import com.saisa.app.admin.dto.UpdateUserStatusRequest;
import com.saisa.app.admin.email.EmailService;
import com.saisa.app.admin.email.EmailSettings;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin")
@PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN')")
public class AdminController {

    private final AdminService adminService;
    private final EmailService emailService;
    private final AdminUserService userService;

    public AdminController(
            AdminService adminService,
            EmailService emailService,
            AdminUserService userService) {
        this.adminService = adminService;
        this.emailService = emailService;
        this.userService = userService;
    }

    // ==================== TENANT ONBOARDING & MANAGEMENT ====================
    @GetMapping("/tenants")
    @PreAuthorize("hasRole('PLATFORM_ADMIN')")
    public ResponseEntity<List<TenantSummaryResponse>> listTenants() {
        return ResponseEntity.ok(adminService.listTenants());
    }

    @PostMapping("/tenants/onboard")
    @PreAuthorize("hasRole('PLATFORM_ADMIN')")
    public ResponseEntity<TenantSummaryResponse> onboardTenant(@Valid @RequestBody OnboardTenantRequest req) {
        return ResponseEntity.ok(adminService.onboardTenant(req));
    }

    @PutMapping("/tenants/{id}/status")
    @PreAuthorize("hasRole('PLATFORM_ADMIN')")
    public ResponseEntity<TenantSummaryResponse> updateTenantStatus(
            @PathVariable Long id,
            @RequestParam String status) {
        return ResponseEntity.ok(adminService.toggleStatus(id, status));
    }

    @PostMapping("/tenants/{id}/inject-license")
    @PreAuthorize("hasRole('PLATFORM_ADMIN')")
    public ResponseEntity<com.saisa.app.license.LicenseStatusResponse> injectLicense(
            @PathVariable Long id,
            @RequestParam(defaultValue = "GROWTH") String plan,
            @RequestParam(defaultValue = "365") Integer durationDays,
            @RequestParam(defaultValue = "5") Integer maxUsers) {
        return ResponseEntity.ok(adminService.injectLicense(id, plan, durationDays, maxUsers));
    }

    // ==================== EMAIL CONFIGURATION & TEST ====================
    @GetMapping("/email-settings")
    public ResponseEntity<EmailSettings> getEmailSettings() {
        return ResponseEntity.ok(emailService.getSettings());
    }

    @PutMapping("/email-settings")
    public ResponseEntity<EmailSettings> updateEmailSettings(@RequestBody EmailSettings settings) {
        return ResponseEntity.ok(emailService.updateSettings(settings));
    }

    @PostMapping("/email-settings/test")
    public ResponseEntity<Map<String, Object>> sendTestEmail(@RequestParam(required = false) String recipient) {
        String sentTo = emailService.sendTestEmail(recipient);
        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "परीक्षण इमेल सफलतापुर्वक पठाइयो (Test email sent successfully)",
            "recipient", sentTo,
            "timestamp", java.time.Instant.now().toString()
        ));
    }

    // ==================== USER MANAGEMENT ====================
    @GetMapping("/users")
    public List<AdminUserResponse> listUsers() {
        return userService.listUsers(TenantContext.getCurrentTenantId());
    }

    @PostMapping("/users")
    public ResponseEntity<AdminUserResponse> createUser(@Valid @RequestBody CreateUserRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long currentUserId = TenantContext.getCurrentUserId();
        AdminUserResponse resp = userService.createUser(tenantId, req, currentUserId);
        return ResponseEntity.status(HttpStatus.CREATED).body(resp);
    }

    @PutMapping("/users/{id}/status")
    public AdminUserResponse updateUserStatus(
            @PathVariable Long id,
            @Valid @RequestBody UpdateUserStatusRequest req) {
        return userService.updateStatus(
            TenantContext.getCurrentTenantId(), id, req.status(),
            TenantContext.getCurrentUserId());
    }

    @PostMapping("/users/{id}/reset-password")
    public ResponseEntity<Void> resetPassword(
            @PathVariable Long id,
            @Valid @RequestBody ResetPasswordRequest req) {
        userService.resetPassword(
            TenantContext.getCurrentTenantId(), id, req.newPassword(),
            TenantContext.getCurrentUserId());
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(
            TenantContext.getCurrentTenantId(), id,
            TenantContext.getCurrentUserId());
        return ResponseEntity.noContent().build();
    }
}
