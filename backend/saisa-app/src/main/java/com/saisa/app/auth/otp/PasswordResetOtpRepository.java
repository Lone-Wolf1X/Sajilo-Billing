package com.saisa.app.auth.otp;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PasswordResetOtpRepository extends JpaRepository<PasswordResetOtp, Long> {

    Optional<PasswordResetOtp> findTopByEmailIgnoreCaseAndUsedFalseOrderByCreatedAtDesc(String email);

    Optional<PasswordResetOtp> findTopByEmailIgnoreCaseAndOtpCodeAndUsedFalse(String email, String otpCode);
}

