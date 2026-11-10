package com.saisa.app.admin;

import com.saisa.app.admin.dto.AdminUserResponse;
import com.saisa.app.admin.dto.CreateUserRequest;
import com.saisa.common.user.Role;
import com.saisa.common.user.RoleRepository;
import com.saisa.common.user.User;
import com.saisa.common.user.UserRepository;
import java.time.Instant;
import java.util.List;
import java.util.Set;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AdminUserService {

    private final UserRepository userRepo;
    private final RoleRepository roleRepo;
    private final PasswordEncoder passwordEncoder;

    public AdminUserService(
            UserRepository userRepo,
            RoleRepository roleRepo,
            PasswordEncoder passwordEncoder) {
        this.userRepo = userRepo;
        this.roleRepo = roleRepo;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional(readOnly = true)
    public List<AdminUserResponse> listUsers(Long tenantId) {
        return userRepo.findByTenantIdOrderByUsername(tenantId).stream()
            .map(u -> AdminUserResponse.from(u, false))
            .toList();
    }

    @Transactional
    public AdminUserResponse createUser(Long tenantId, CreateUserRequest req, Long currentUserId) {
        // Username unique within tenant
        if (userRepo.existsByTenantIdAndUsername(tenantId, req.username())) {
            throw new ResponseStatusException(
                HttpStatus.CONFLICT, "Username already exists in this company: " + req.username());
        }
        // Email unique within tenant
        if (userRepo.existsByTenantIdAndEmail(tenantId, req.email())) {
            throw new ResponseStatusException(
                HttpStatus.CONFLICT, "Email already in use: " + req.email());
        }

        // Resolve role
        String code = req.roleCode().toUpperCase();
        if (!Set.of("ADMIN", "ACCOUNTANT", "CASHIER", "VIEWER").contains(code)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid role: " + req.roleCode());
        }
        Role role = roleRepo.findByRoleCode(code)
            .orElseThrow(() -> new ResponseStatusException(
                HttpStatus.BAD_REQUEST, "Role not found: " + code));

        User u = new User();
        u.setTenantId(tenantId);
        u.setUsername(req.username());
        u.setEmail(req.email());
        u.setPasswordHash(passwordEncoder.encode(req.password()));
        u.setFullName(req.fullName());
        u.setStatus("ACTIVE");
        u.setRoles(Set.of(role));
        u.setCreatedBy(currentUserId);
        u.setUpdatedBy(currentUserId);
        u = userRepo.save(u);

        return AdminUserResponse.from(u, false);
    }

    @Transactional
    public AdminUserResponse updateStatus(Long tenantId, Long userId, String status, Long currentUserId) {
        if (!Set.of("ACTIVE", "DISABLED").contains(status)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid status: " + status);
        }
        if (userId.equals(currentUserId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cannot change your own status");
        }

        User u = requireTenantUser(tenantId, userId);

        // Prevent disabling the last remaining ADMIN
        if ("DISABLED".equals(status) && isUserAdmin(u)) {
            long activeAdmins = userRepo.findByTenantIdOrderByUsername(tenantId)
                .stream()
                .filter(x -> "ACTIVE".equals(x.getStatus()) && isUserAdmin(x))
                .count();
            if (activeAdmins <= 1) {
                throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Cannot disable the last active administrator");
            }
        }

        u.setStatus(status);
        u.setUpdatedBy(currentUserId);
        return AdminUserResponse.from(userRepo.save(u), false);
    }

    @Transactional
    public void resetPassword(Long tenantId, Long userId, String newPassword, Long currentUserId) {
        User u = requireTenantUser(tenantId, userId);
        u.setPasswordHash(passwordEncoder.encode(newPassword));
        u.setFailedLoginAttempts(0);
        u.setLockedUntil(null);
        u.setUpdatedBy(currentUserId);
        userRepo.save(u);
    }

    @Transactional
    public void deleteUser(Long tenantId, Long userId, Long currentUserId) {
        if (userId.equals(currentUserId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cannot delete your own account");
        }
        User u = requireTenantUser(tenantId, userId);
        if (isUserAdmin(u)) {
            long admins = userRepo.findByTenantIdOrderByUsername(tenantId)
                .stream()
                .filter(this::isUserAdmin)
                .count();
            if (admins <= 1) {
                throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Cannot delete the last administrator");
            }
        }
        // Soft delete via status; hard delete would break audit trails
        u.setStatus("DISABLED");
        u.setUsername(u.getUsername() + "_DELETED_" + Instant.now().toEpochMilli());
        u.setUpdatedBy(currentUserId);
        userRepo.save(u);
    }

    private User requireTenantUser(Long tenantId, Long userId) {
        User u = userRepo.findById(userId)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
        if (!u.getTenantId().equals(tenantId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }
        return u;
    }

    private boolean isUserAdmin(User u) {
        return u.getRoles().stream()
            .anyMatch(r -> "ADMIN".equals(r.getRoleCode()));
    }
}

