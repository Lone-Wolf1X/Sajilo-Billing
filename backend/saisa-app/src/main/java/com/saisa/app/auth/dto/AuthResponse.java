package com.saisa.app.auth.dto;

public record AuthResponse(
    String accessToken,
    String refreshToken,
    String tokenType,
    long expiresInSeconds,
    Long userId,
    Long tenantId,
    String tenantCode
) {
    public AuthResponse(String accessToken, String refreshToken, long expiresInSeconds,
                        Long userId, Long tenantId, String tenantCode) {
        this(accessToken, refreshToken, "Bearer", expiresInSeconds, userId, tenantId, tenantCode);
    }
}

