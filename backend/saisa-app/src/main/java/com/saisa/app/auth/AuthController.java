package com.saisa.app.auth;

import com.saisa.app.auth.dto.AuthResponse;
import com.saisa.app.auth.dto.ForgotPasswordRequest;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.auth.dto.RefreshRequest;
import com.saisa.app.auth.dto.RegisterTenantRequest;
import com.saisa.app.auth.dto.ResetPasswordWithOtpRequest;
import com.saisa.app.auth.otp.PasswordResetService;
import jakarta.validation.Valid;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;
    private final PasswordResetService passwordResetService;

    public AuthController(AuthService authService, PasswordResetService passwordResetService) {
        this.authService = authService;
        this.passwordResetService = passwordResetService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterTenantRequest req) {
        return ResponseEntity.ok(authService.registerTenant(req));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest req) {
        return ResponseEntity.ok(authService.login(req));
    }

    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refresh(@Valid @RequestBody RefreshRequest req) {
        return ResponseEntity.ok(authService.refresh(req.refreshToken()));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<Map<String, Object>> forgotPassword(@Valid @RequestBody ForgotPasswordRequest req) {
        return ResponseEntity.ok(passwordResetService.sendResetOtp(req));
    }

    @PostMapping("/reset-password-otp")
    public ResponseEntity<Map<String, Object>> resetPasswordWithOtp(@Valid @RequestBody ResetPasswordWithOtpRequest req) {
        return ResponseEntity.ok(passwordResetService.resetPasswordWithOtp(req));
    }
}

