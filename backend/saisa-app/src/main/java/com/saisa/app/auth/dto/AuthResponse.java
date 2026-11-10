package com.saisa.app.auth.dto;

import java.util.List;

public record AuthResponse(
    String accessToken,
    String refreshToken,
    String tokenType,
    long expiresInSeconds,
    Long userId,
    Long tenantId,
    String tenantCode,
    List<String> roles
) {
    public AuthResponse(String accessToken, String refreshToken, long expiresInSeconds,
                        Long userId, Long tenantId, String tenantCode, List<String> roles) {
        this(accessToken, refreshToken, "Bearer", expiresInSeconds, userId, tenantId, tenantCode, roles);
    }

    public AuthResponse(String accessToken, String refreshToken, long expiresInSeconds,
                        Long userId, Long tenantId, String tenantCode) {
        this(accessToken, refreshToken, "Bearer", expiresInSeconds, userId, tenantId, tenantCode, List.of());
    }
}

