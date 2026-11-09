package com.saisa.app.setup;

import com.saisa.common.tenant.dto.CompanyProfileResponse;
import com.saisa.common.tenant.dto.SetupStatusResponse;
import com.saisa.common.tenant.dto.UpdateProfileRequest;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/setup")
public class SetupController {

    private final ProfileSetupService setupService;

    public SetupController(ProfileSetupService setupService) {
        this.setupService = setupService;
    }

    @GetMapping("/profile")
    public ResponseEntity<CompanyProfileResponse> getProfile() {
        return ResponseEntity.ok(setupService.getProfile());
    }

    @PutMapping("/profile")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<CompanyProfileResponse> updateProfile(@Valid @RequestBody UpdateProfileRequest req) {
        return ResponseEntity.ok(setupService.updateProfile(req));
    }

    @GetMapping("/status")
    public ResponseEntity<SetupStatusResponse> getStatus() {
        return ResponseEntity.ok(setupService.getStatus());
    }

    @PostMapping("/complete")
    @PreAuthorize("hasRole('ADMIN')")
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
}
