package com.saisa.app.auth;

import com.saisa.app.auth.dto.AuthResponse;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.auth.dto.RegisterTenantRequest;
import com.saisa.app.security.JwtService;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.user.Role;
import com.saisa.common.user.RoleRepository;
import com.saisa.common.user.User;
import com.saisa.common.user.UserRepository;
import java.time.Instant;
import java.util.List;
import java.util.Set;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final TenantRepository tenantRepo;
    private final UserRepository userRepo;
    private final RoleRepository roleRepo;
    private final ChartOfAccountRepository accountRepo;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authManager;
    private final JwtService jwtService;
    private final RefreshTokenService refreshTokenService;

    public AuthService(TenantRepository tenantRepo,
                       UserRepository userRepo,
                       RoleRepository roleRepo,
                       ChartOfAccountRepository accountRepo,
                       PasswordEncoder passwordEncoder,
                       AuthenticationManager authManager,
                       JwtService jwtService,
                       RefreshTokenService refreshTokenService) {
        this.tenantRepo = tenantRepo;
        this.userRepo = userRepo;
        this.roleRepo = roleRepo;
        this.accountRepo = accountRepo;
        this.passwordEncoder = passwordEncoder;
        this.authManager = authManager;
        this.jwtService = jwtService;
        this.refreshTokenService = refreshTokenService;
    }

    @Transactional
    public AuthResponse registerTenant(RegisterTenantRequest req) {
        if (tenantRepo.existsByTenantCode(req.tenantCode())) {
            throw new IllegalArgumentException("Tenant code already taken");
        }

        Tenant tenant = new Tenant();
        tenant.setTenantCode(req.tenantCode());
        tenant.setCompanyName(req.companyName());
        tenant = tenantRepo.save(tenant);

        // Seed system accounts - required for billing to work
        seedSystemAccounts(tenant.getId());

        Role adminRole = roleRepo.findByRoleCode("ADMIN")
            .orElseThrow(() -> new IllegalStateException("ADMIN role missing"));

        User admin = new User();
        admin.setTenantId(tenant.getId());
        admin.setUsername(req.username());
        admin.setEmail(req.email());
        admin.setPasswordHash(passwordEncoder.encode(req.password()));
        admin.setFullName(req.fullName());
        admin.setRoles(Set.of(adminRole));
        admin = userRepo.save(admin);

        return issueTokens(admin);
    }

    private void seedSystemAccounts(Long tenantId) {
        seedAccount(tenantId, "AR", "Accounts Receivable", AccountType.ASSET);
        seedAccount(tenantId, "AP", "Accounts Payable", AccountType.LIABILITY);
        seedAccount(tenantId, "INVENTORY_ASSET", "Inventory Asset", AccountType.ASSET);
        seedAccount(tenantId, "GST_OUTPUT", "GST Output Payable", AccountType.LIABILITY);
        seedAccount(tenantId, "GST_INPUT", "GST Input Credit", AccountType.ASSET);
        seedAccount(tenantId, "SALES", "Sales Revenue", AccountType.INCOME);
        seedAccount(tenantId, "PURCHASE", "Purchase Expense", AccountType.EXPENSE);
        seedAccount(tenantId, "COGS", "Cost of Goods Sold", AccountType.EXPENSE);
        seedAccount(tenantId, "CASH", "Cash", AccountType.ASSET);
        seedAccount(tenantId, "BANK", "Bank", AccountType.ASSET);
    }

    private void seedAccount(Long tenantId, String code, String name, AccountType type) {
        ChartOfAccount acc = new ChartOfAccount();
        acc.setTenantId(tenantId);
        acc.setAccountCode(code);
        acc.setAccountName(name);
        acc.setAccountType(type);
        acc.setSystemAccount(true);
        accountRepo.save(acc);
    }

    @Transactional
    public AuthResponse login(LoginRequest req) {
        Tenant tenant = tenantRepo.findByTenantCode(req.tenantCode())
            .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));
        if (!tenant.isActive()) {
            throw new IllegalArgumentException("Tenant is not active");
        }

        // Delegate password verification + load user via Spring Security
        var auth = authManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                req.tenantCode() + ":" + req.username(), req.password()));

        User user = userRepo.findByTenantIdAndUsername(tenant.getId(), req.username())
            .orElseThrow(() -> new IllegalStateException("Authenticated user missing"));

        user.setLastLoginAt(Instant.now());
        user.setFailedLoginAttempts(0);

        return issueTokens(user);
    }

    private AuthResponse issueTokens(User user) {
        List<String> roles = user.getRoles().stream()
            .map(Role::getRoleCode).toList();

        String accessToken = jwtService.generateAccessToken(
            user.getId(), user.getTenantId(), roles);
        String refreshToken = refreshTokenService.issue(user.getId());

        String tenantCode = tenantRepo.findById(user.getTenantId())
            .map(Tenant::getTenantCode).orElse("");

        return new AuthResponse(
            accessToken, refreshToken, 900,  // 15 minutes
            user.getId(), user.getTenantId(), tenantCode);
    }

    @Transactional
    public AuthResponse refresh(String rawRefreshToken) {
        RefreshToken stored = refreshTokenService.validate(rawRefreshToken);
        User user = userRepo.findById(stored.getUserId())
            .orElseThrow(() -> new IllegalArgumentException("User no longer exists"));

        // Rotate: revoke old, issue new (prevents replay)
        refreshTokenService.revoke(rawRefreshToken);
        return issueTokens(user);
    }
}

