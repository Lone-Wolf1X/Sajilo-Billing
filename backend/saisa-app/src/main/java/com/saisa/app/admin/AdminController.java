package com.saisa.app.admin;

import com.saisa.app.admin.dto.OnboardTenantRequest;
import com.saisa.app.admin.dto.TenantSummaryResponse;
import com.saisa.app.admin.email.EmailService;
import com.saisa.app.admin.email.EmailSettings;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.http.ResponseEntity;
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
public class AdminController {

    private final AdminService adminService;
    private final EmailService emailService;

    public AdminController(AdminService adminService, EmailService emailService) {
        this.adminService = adminService;
        this.emailService = emailService;
    }

    // ==================== TENANT ONBOARDING & MANAGEMENT ====================
    @GetMapping("/tenants")
    public ResponseEntity<List<TenantSummaryResponse>> listTenants() {
        return ResponseEntity.ok(adminService.listTenants());
    }

    @PostMapping("/tenants/onboard")
    public ResponseEntity<TenantSummaryResponse> onboardTenant(@Valid @RequestBody OnboardTenantRequest req) {
        return ResponseEntity.ok(adminService.onboardTenant(req));
    }

    @PutMapping("/tenants/{id}/status")
    public ResponseEntity<TenantSummaryResponse> updateTenantStatus(
            @PathVariable Long id,
            @RequestParam String status) {
        return ResponseEntity.ok(adminService.toggleStatus(id, status));
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
}

