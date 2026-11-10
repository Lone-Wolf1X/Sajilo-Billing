package com.saisa.app.auth.otp;

import com.saisa.app.admin.email.EmailService;
import com.saisa.app.auth.dto.ForgotPasswordRequest;
import com.saisa.app.auth.dto.ResetPasswordWithOtpRequest;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.user.User;
import com.saisa.common.user.UserRepository;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PasswordResetService {

    private static final Logger log = LoggerFactory.getLogger(PasswordResetService.class);
    private static final SecureRandom RANDOM = new SecureRandom();

    private final UserRepository userRepo;
    private final TenantRepository tenantRepo;
    private final PasswordResetOtpRepository otpRepo;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    public PasswordResetService(
            UserRepository userRepo,
            TenantRepository tenantRepo,
            PasswordResetOtpRepository otpRepo,
            EmailService emailService,
            PasswordEncoder passwordEncoder) {
        this.userRepo = userRepo;
        this.tenantRepo = tenantRepo;
        this.otpRepo = otpRepo;
        this.emailService = emailService;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public Map<String, Object> sendResetOtp(ForgotPasswordRequest req) {
        String targetEmail = req.email().trim().toLowerCase();
        User user;

        if (req.tenantCode() != null && !req.tenantCode().isBlank()) {
            Tenant tenant = tenantRepo.findByTenantCode(req.tenantCode().trim())
                .orElseThrow(() -> new IllegalArgumentException("कम्पनी कोड फेला परेन (Tenant not found)"));
            user = userRepo.findByTenantIdAndEmailIgnoreCase(tenant.getId(), targetEmail)
                .orElseThrow(() -> new IllegalArgumentException("यस कम्पनीमा यो इमेल दर्ता भएको छैन (User not found with this email)"));
        } else {
            user = userRepo.findFirstByEmailIgnoreCase(targetEmail)
                .orElseThrow(() -> new IllegalArgumentException("यस इमेल भएको प्रयोगकर्ता फेला परेन (No user found with this email)"));
        }

        // Generate 6-digit numeric OTP
        int codeInt = 100000 + RANDOM.nextInt(900000);
        String otpCode = String.valueOf(codeInt);

        // Invalidate any existing unused OTP for this email
        otpRepo.findTopByEmailIgnoreCaseAndUsedFalseOrderByCreatedAtDesc(targetEmail).ifPresent(prev -> {
            prev.setUsed(true);
            otpRepo.save(prev);
        });

        // Save new OTP valid for 15 minutes
        PasswordResetOtp otp = new PasswordResetOtp();
        otp.setUserId(user.getId());
        otp.setEmail(targetEmail);
        otp.setOtpCode(otpCode);
        otp.setExpiresAt(Instant.now().plus(Duration.ofMinutes(15)));
        otp.setUsed(false);
        otp.setAttempts(0);
        otpRepo.save(otp);

        // Send Email via Gmail SMTP
        sendOtpEmail(user, targetEmail, otpCode);

        log.info("Password reset OTP generated and sent to user {} ({})", user.getUsername(), targetEmail);

        return Map.of(
            "success", true,
            "message", "६-अङ्कको OTP कोड तपाईंको इमेलमा पठाइएको छ। कृपया आफ्नो इनबक्स जाँच गर्नुहोस्।",
            "email", maskEmail(targetEmail)
        );
    }

    @Transactional
    public Map<String, Object> resetPasswordWithOtp(ResetPasswordWithOtpRequest req) {
        String targetEmail = req.email().trim().toLowerCase();
        String submittedOtp = req.otp().trim();

        PasswordResetOtp otp = otpRepo.findTopByEmailIgnoreCaseAndUsedFalseOrderByCreatedAtDesc(targetEmail)
            .orElseThrow(() -> new IllegalArgumentException("कुनै सक्रिय OTP अनुरोध फेला परेन। कृपया पुनः OTP माग्नुहोस्।"));

        if (Instant.now().isAfter(otp.getExpiresAt())) {
            otp.setUsed(true);
            otpRepo.save(otp);
            throw new IllegalArgumentException("OTP को म्याद समाप्त भइसकेको छ। कृपया नयाँ OTP कोड अनुरोध गर्नुहोस्।");
        }

        if (otp.getAttempts() >= 5) {
            otp.setUsed(true);
            otpRepo.save(otp);
            throw new IllegalArgumentException("धेरै पटक गलत OTP प्रविष्ट गरियो। सुरक्षा कारणले नयाँ OTP कोड माग्नुहोस्।");
        }

        if (!otp.getOtpCode().equals(submittedOtp)) {
            otp.setAttempts(otp.getAttempts() + 1);
            otpRepo.save(otp);
            int remaining = 5 - otp.getAttempts();
            throw new IllegalArgumentException("गलत OTP कोड। बाँकी प्रयास: " + remaining);
        }

        // OTP Verified successfully!
        otp.setUsed(true);
        otpRepo.save(otp);

        User user = userRepo.findById(otp.getUserId())
            .orElseThrow(() -> new IllegalStateException("प्रयोगकर्ता फेला परेन"));

        // Hash new password and save
        user.setPasswordHash(passwordEncoder.encode(req.newPassword().trim()));
        user.setFailedLoginAttempts(0);
        user.setLockedUntil(null);
        user.setUpdatedAt(Instant.now());
        userRepo.save(user);

        // Send confirmation email
        sendPasswordChangedConfirmation(user, targetEmail);

        log.info("Password successfully reset via OTP for user {} ({})", user.getUsername(), targetEmail);

        return Map.of(
            "success", true,
            "message", "पासवर्ड सफलतापूर्वक परिवर्तन भयो! अब नयाँ पासवर्ड प्रयोग गरी लगइन गर्नुहोस्।"
        );
    }

    private void sendOtpEmail(User user, String toEmail, String otpCode) {
        String html = "<div style=\"font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 580px; margin: 0 auto; padding: 32px 24px; background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);\">"
            + "<div style=\"text-align: center; margin-bottom: 24px;\">"
            + "  <div style=\"display: inline-block; width: 48px; height: 48px; line-height: 48px; background-color: #1e3a5f; color: #ffffff; font-size: 24px; font-weight: bold; border-radius: 8px;\">S</div>"
            + "  <h2 style=\"margin: 12px 0 4px 0; color: #0f172a; font-size: 22px;\">SAISA Pro • पासवर्ड रिसेट OTP</h2>"
            + "  <p style=\"margin: 0; color: #64748b; font-size: 13px;\">NextGen Innovations • Enterprise Accounting & POS</p>"
            + "</div>"
            + "<p style=\"color: #334155; font-size: 14px; line-height: 1.6;\">नमस्ते <strong>" + (user.getFullName() != null ? user.getFullName() : user.getUsername()) + "</strong>,</p>"
            + "<p style=\"color: #334155; font-size: 14px; line-height: 1.6;\">तपाईंको SAISA Pro खाता (प्रयोगकर्ता: <code>" + user.getUsername() + "</code>) को पासवर्ड रिसेट गर्न अनुरोध प्राप्त भएको छ। कृपया तल दिइएको ६-अङ्कको गोप्य प्रमाणीकरण कोड (OTP) प्रयोग गर्नुहोस्:</p>"
            + "<div style=\"margin: 28px 0; text-align: center;\">"
            + "  <div style=\"display: inline-block; background: linear-gradient(135deg, #f8fafc, #edf2f7); border: 2px dashed #3b82f6; border-radius: 12px; padding: 16px 36px;\">"
            + "    <span style=\"font-family: monospace, Courier; font-size: 34px; font-weight: 800; letter-spacing: 8px; color: #1e3a5f;\">" + otpCode + "</span>"
            + "  </div>"
            + "  <p style=\"color: #64748b; font-size: 12px; margin-top: 8px;\">यो कोड १५ मिनेटसम्म मात्र मान्य रहनेछ।</p>"
            + "</div>"
            + "<div style=\"background-color: #fef2f2; border-left: 4px solid #ef4444; padding: 12px 16px; border-radius: 4px; margin-bottom: 24px;\">"
            + "  <p style=\"color: #991b1b; font-size: 12px; margin: 0; font-weight: 500;\">⚠️ सुरक्षा सूचना: यो कोड कसैसँग पनि शेयर नगर्नुहोस्। यदि तपाईंले यो अनुरोध गर्नुभएको होइन भने, तुरुन्तै प्रणाली प्रशासकलाई जानकारी गराउनुहोस्।</p>"
            + "</div>"
            + "<hr style=\"border: none; border-top: 1px solid #e2e8f0; margin: 24px 0;\" />"
            + "<p style=\"color: #94a3b8; font-size: 11px; text-align: center; margin: 0;\">© " + java.time.Year.now().getValue() + " NextGen Innovations Pvt. Ltd., Nepal. All rights reserved.</p>"
            + "</div>";

        emailService.sendEmail(toEmail, "🔒 SAISA Pro पासवर्ड रिसेट OTP: " + otpCode, html);
    }

    private void sendPasswordChangedConfirmation(User user, String toEmail) {
        try {
            String html = "<div style=\"font-family: sans-serif; max-width: 580px; margin: 0 auto; padding: 24px; border: 1px solid #e2e8f0; border-radius: 8px;\">"
                + "<h3 style=\"color: #059669; margin-top: 0;\">✓ पासवर्ड सफलतापूर्वक परिवर्तन भयो</h3>"
                + "<p style=\"color: #334155; font-size: 14px;\">नमस्ते " + user.getUsername() + ", तपाईंको खाताको पासवर्ड भर्खरै सफलतापूर्वक परिवर्तन भएको छ। अब नयाँ पासवर्ड प्रयोग गरी लगइन गर्न सक्नुहुनेछ।</p>"
                + "<p style=\"color: #64748b; font-size: 12px;\">समय: " + Instant.now().toString() + "</p>"
                + "</div>";
            emailService.sendEmail(toEmail, "✓ SAISA Pro पासवर्ड परिवर्तन सफल", html);
        } catch (Exception ex) {
            log.warn("Could not send password changed confirmation email: {}", ex.getMessage());
        }
    }

    private String maskEmail(String email) {
        int at = email.indexOf('@');
        if (at <= 2) return email;
        return email.charAt(0) + "***" + email.substring(at - 1);
    }
}

