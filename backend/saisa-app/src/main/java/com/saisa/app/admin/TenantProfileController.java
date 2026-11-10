package com.saisa.app.admin;

import com.saisa.app.setup.ProfileSetupService;
import com.saisa.common.tenant.dto.CompanyProfileResponse;
import com.saisa.common.tenant.dto.UpdateProfileRequest;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Controller allowing tenant administrators (business owners) to view and update
 * their business profile and official contact information without accessing
 * the protected platform-level setup wizard.
 */
@RestController
@RequestMapping("/api/v1/admin/profile")
@PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN')")
public class TenantProfileController {

    private final ProfileSetupService profileService;

    public TenantProfileController(ProfileSetupService profileService) {
        this.profileService = profileService;
    }

    @GetMapping
    public ResponseEntity<CompanyProfileResponse> getProfile() {
        return ResponseEntity.ok(profileService.getProfile());
    }

    @PutMapping
    public ResponseEntity<CompanyProfileResponse> updateProfile(@Valid @RequestBody UpdateProfileRequest req) {
        return ResponseEntity.ok(profileService.updateProfile(req));
    }
}

