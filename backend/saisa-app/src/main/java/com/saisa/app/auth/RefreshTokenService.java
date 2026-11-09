package com.saisa.app.auth;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RefreshTokenService {

    private final RefreshTokenRepository repository;
    private final SecureRandom random = new SecureRandom();

    public RefreshTokenService(RefreshTokenRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public String issue(Long userId) {
        byte[] raw = new byte[64];
        random.nextBytes(raw);
        String rawToken = Base64.getUrlEncoder().withoutPadding().encodeToString(raw);

        RefreshToken token = new RefreshToken();
        token.setUserId(userId);
        token.setTokenHash(hash(rawToken));
        token.setExpiresAt(Instant.now().plus(7, ChronoUnit.DAYS));
        repository.save(token);

        return rawToken;  // raw token only returned to client, never stored
    }

    @Transactional
    public RefreshToken validate(String rawToken) {
        RefreshToken t = repository.findByTokenHashAndRevokedFalse(hash(rawToken))
            .orElseThrow(() -> new IllegalArgumentException("Invalid refresh token"));
        if (t.getExpiresAt().isBefore(Instant.now())) {
            throw new IllegalArgumentException("Refresh token expired");
        }
        return t;
    }

    @Transactional
    public void revoke(String rawToken) {
        repository.findByTokenHashAndRevokedFalse(hash(rawToken))
            .ifPresent(t -> {
                t.setRevoked(true);
                t.setRevokedAt(Instant.now());
            });
    }

    private String hash(String raw) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256")
                .digest(raw.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(digest);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 not available", e);
        }
    }
}
