package com.saisa.app.admin.dto;

import com.saisa.common.user.User;
import java.time.Instant;
import java.util.List;

public record AdminUserResponse(
    Long id,
    String username,
    String email,
    String fullName,
    String status,             // ACTIVE, DISABLED, LOCKED
    List<String> roles,        // roleCodes
    Instant lastLoginAt,
    Instant createdAt,
    boolean systemUser         // true for bootstrap admin
) {
    public static AdminUserResponse from(User u, boolean isSystemUser) {
        return new AdminUserResponse(
            u.getId(),
            u.getUsername(),
            u.getEmail(),
            u.getFullName(),
            u.getStatus(),
            u.getRoles().stream()
                .map(r -> r.getRoleCode())
                .sorted()
                .toList(),
            u.getLastLoginAt(),
            u.getCreatedAt(),
            isSystemUser
        );
    }
}

