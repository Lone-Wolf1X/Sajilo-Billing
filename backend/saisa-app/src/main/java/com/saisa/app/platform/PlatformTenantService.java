package com.saisa.app.platform;

import com.saisa.app.license.LicenseContainer;
import com.saisa.app.license.LicensePlan;
import com.saisa.app.license.LicenseSignerService;
import com.saisa.app.license.LicenseStatusResponse;
import com.saisa.app.license.LicenseVerifierService;
import com.saisa.app.license.TenantLicenseRepository;
import com.saisa.app.platform.dto.CreateTenantRequest;
import com.saisa.app.platform.dto.CreateTenantResponse;
import com.saisa.app.platform.dto.InjectLicenseRequest;
import com.saisa.app.platform.dto.TenantSummaryResponse;
import com.saisa.common.tenant.BusinessNature;
import com.saisa.common.tenant.IncorporationType;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.user.Role;
import com.saisa.common.user.RoleRepository;
import com.saisa.common.user.User;
import com.saisa.common.user.UserRepository;
import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PlatformTenantService {

    private static final Logger log = LoggerFactory.getLogger(PlatformTenantService.class);
    private static final SecureRandom RNG = new SecureRandom();

    private final TenantRepository tenantRepo;
    private final UserRepository userRepo;
    private final RoleRepository roleRepo;
    private final ChartOfAccountRepository accountRepo;
    private final TenantLicenseRepository licenseRepo;
    private final LicenseSignerService signerService;
    private final LicenseVerifierService verifierService;
    private final DemoLeadRepository demoLeadRepo;
    private final PasswordEncoder passwordEncoder;

    public PlatformTenantService(
            TenantRepository tenantRepo,
            UserRepository userRepo,
            RoleRepository roleRepo,
            ChartOfAccountRepository accountRepo,
            TenantLicenseRepository licenseRepo,
            LicenseSignerService signerService,
            LicenseVerifierService verifierService,
            DemoLeadRepository demoLeadRepo,
            PasswordEncoder passwordEncoder) {
        this.tenantRepo = tenantRepo;
        this.userRepo = userRepo;
        this.roleRepo = roleRepo;
        this.accountRepo = accountRepo;
        this.licenseRepo = licenseRepo;
        this.signerService = signerService;
        this.verifierService = verifierService;
        this.demoLeadRepo = demoLeadRepo;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional(readOnly = true)
    public List<TenantSummaryResponse> listTenants() {
        return tenantRepo.findAllByTenantCodeNotOrderByCreatedAtDesc("_platform").stream()
            .map(this::toSummary)
            .toList();
    }

    @Transactional
    public CreateTenantResponse createTenant(CreateTenantRequest req, Long createdBy) {
        // 1. Validate tenant code
        String tenantCode = req.tenantCode().trim().toLowerCase();
        if (tenantCode.length() < 3) {
            throw new IllegalArgumentException("Tenant code must be at least 3 characters");
        }
        if (tenantRepo.existsByTenantCode(tenantCode)) {
            throw new IllegalArgumentException("Tenant code already exists: " + tenantCode);
        }
        if ("_platform".equals(tenantCode)) {
            throw new IllegalArgumentException("Reserved tenant code: _platform");
        }

        // 2. Validate email is present and valid
        if (req.adminEmail() == null || req.adminEmail().isBlank()) {
            throw new IllegalArgumentException("Admin email is strictly mandatory for onboarding and credentials delivery");
        }

        // 3. Create tenant
        Tenant tenant = new Tenant();
        tenant.setTenantCode(tenantCode);
        tenant.setCompanyName(req.companyName().trim());
        tenant.setCompanyNameNepali(req.companyNameNepali() != null ? req.companyNameNepali().trim() : null);
        tenant.setLegalName(req.legalName() != null ? req.legalName().trim() : null);
        tenant.setCountry("Nepal");
        tenant.setStatus("ACTIVE");
        tenant.setFiscalYearStartMonth(4);
        tenant.setSetupCompleted(true);
        tenant.setSetupStep(3);
        tenant.setSetupCompletedAt(Instant.now());
        tenant.setCreatedBy(createdBy);

        if (req.registrationNo() != null && !req.registrationNo().isBlank()) {
            tenant.setRegistrationNo(req.registrationNo().trim());
        }
        if (req.panVatNo() != null && !req.panVatNo().isBlank()) {
            tenant.setPanVatNo(req.panVatNo().trim());
        }
        if (req.province() != null && !req.province().isBlank()) {
            tenant.setProvince(req.province().trim());
        }
        if (req.district() != null && !req.district().isBlank()) {
            tenant.setDistrict(req.district().trim());
        }
        if (req.municipalityVdc() != null && !req.municipalityVdc().isBlank()) {
            tenant.setMunicipalityVdc(req.municipalityVdc().trim());
        }
        if (req.wardNo() != null && !req.wardNo().isBlank()) {
            try {
                tenant.setWardNo(Integer.parseInt(req.wardNo().trim()));
            } catch (NumberFormatException ignored) {}
        }
        if (req.incorporationType() != null && !req.incorporationType().isBlank()) {
            String typeStr = req.incorporationType().trim().toUpperCase();
            if ("PRIVATE_LTD".equals(typeStr)) {
                typeStr = "PRIVATE_LIMITED";
            } else if ("PUBLIC_LTD".equals(typeStr)) {
                typeStr = "PUBLIC_LIMITED";
            }
            try {
                tenant.setIncorporationType(IncorporationType.valueOf(typeStr));
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Invalid incorporation type: " + req.incorporationType());
            }
        }
        if (req.businessNature() != null && !req.businessNature().isBlank()) {
            try {
                tenant.setBusinessNature(BusinessNature.valueOf(req.businessNature().trim().toUpperCase()));
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Invalid business nature: " + req.businessNature());
            }
        }

        tenant = tenantRepo.save(tenant);

        // 4. Seed standard chart of accounts
        seedSystemAccounts(tenant.getId());

        // 5. Determine admin password
        String generatedPassword = null;
        String password;
        boolean passwordWasGenerated;
        if (req.adminPassword() != null && !req.adminPassword().isBlank()) {
            password = req.adminPassword();
            passwordWasGenerated = false;
        } else {
            generatedPassword = generateSecurePassword();
            password = generatedPassword;
            passwordWasGenerated = true;
        }

        // 6. Create admin user
        Role adminRole = roleRepo.findByRoleCode("ADMIN")
            .orElseThrow(() -> new IllegalStateException("ADMIN role missing in database"));

        User admin = new User();
        admin.setTenantId(tenant.getId());
        admin.setUsername(req.adminUsername().trim().toLowerCase());
        admin.setEmail(req.adminEmail().trim().toLowerCase());
        admin.setPasswordHash(passwordEncoder.encode(password));
        admin.setFullName(req.adminFullName() != null && !req.adminFullName().isBlank()
            ? req.adminFullName().trim() : req.adminUsername().trim());
        admin.setStatus("ACTIVE");
        admin.setRoles(Set.of(adminRole));
        admin.setCreatedBy(createdBy);
        admin = userRepo.save(admin);

        // 7. Bind initial cryptographic license
        LicensePlan plan = LicensePlan.TRIAL;
        if (req.licensePlan() != null && !req.licensePlan().isBlank()) {
            try {
                plan = LicensePlan.valueOf(req.licensePlan().trim().toUpperCase());
            } catch (IllegalArgumentException ignored) {}
        }
        int durationDays = (req.licenseDurationDays() != null && req.licenseDurationDays() > 0)
            ? req.licenseDurationDays()
            : (plan == LicensePlan.TRIAL ? 30 : 365);
        int maxUsers = (req.maxUsers() != null && req.maxUsers() > 0) ? req.maxUsers() : 5;

        try {
            LicenseContainer container = signerService.generateLicense(
                tenant.getTenantCode(),
                tenant.getCompanyName(),
                tenant.getPanVatNo(),
                plan,
                durationDays,
                maxUsers,
                null
            );
            verifierService.activateLicense(tenant.getId(), container);
            log.info("Bound initial license [{}] for tenant '{}'", plan, tenant.getTenantCode());
        } catch (Exception e) {
            log.error("Failed to bind initial license for tenant '{}': {}", tenant.getTenantCode(), e.getMessage());
        }

        log.info("Platform admin created tenant '{}' (id={}) with admin user '{}' (id={})",
            tenantCode, tenant.getId(), admin.getUsername(), admin.getId());

        return new CreateTenantResponse(
            tenant.getId(),
            tenant.getTenantCode(),
            tenant.getCompanyName(),
            admin.getUsername(),
            admin.getEmail(),
            generatedPassword,
            passwordWasGenerated
        );
    }

    @Transactional
    public LicenseStatusResponse injectLicense(Long tenantId, InjectLicenseRequest req) {
        Tenant tenant = tenantRepo.findById(tenantId)
            .orElseThrow(() -> new IllegalArgumentException("Tenant not found with ID: " + tenantId));

        LicensePlan plan = LicensePlan.GROWTH;
        if (req.plan() != null && !req.plan().isBlank()) {
            try {
                plan = LicensePlan.valueOf(req.plan().trim().toUpperCase());
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Invalid license plan: " + req.plan());
            }
        }

        int durationDays = (req.durationDays() != null && req.durationDays() > 0) ? req.durationDays() : 365;
        int maxUsers = (req.maxUsers() != null && req.maxUsers() > 0) ? req.maxUsers() : 5;

        LicenseContainer container = signerService.generateLicense(
            tenant.getTenantCode(),
            tenant.getCompanyName(),
            tenant.getPanVatNo(),
            plan,
            durationDays,
            maxUsers,
            req.allowedFeatures()
        );

        LicenseStatusResponse activated = verifierService.activateLicense(tenant.getId(), container);
        log.info("Platform Admin injected license plan '{}' (valid for {} days) for tenant '{}' (id={})",
            plan, durationDays, tenant.getTenantCode(), tenant.getId());

        return activated;
    }

    @Transactional(readOnly = true)
    public List<DemoLead> listDemoLeads() {
        return demoLeadRepo.findAllByOrderByCreatedAtDesc();
    }

    @Transactional
    public DemoLead updateDemoLeadStatus(Long leadId, String status) {
        DemoLead lead = demoLeadRepo.findById(leadId)
            .orElseThrow(() -> new IllegalArgumentException("Lead not found with ID: " + leadId));
        lead.setStatus(status.trim().toUpperCase());
        lead.setUpdatedAt(Instant.now());
        return demoLeadRepo.save(lead);
    }

    private TenantSummaryResponse toSummary(Tenant t) {
        long userCount = userRepo.findByTenantIdOrderByUsername(t.getId()).size();

        TenantSummaryResponse.LicenseSummary license = licenseRepo
            .findFirstByTenantIdAndActiveTrueOrderByExpiresAtDesc(t.getId())
            .map(l -> {
                long daysRemaining = Duration.between(Instant.now(), l.getExpiresAt()).toDays();
                String status = l.isActive()
                    ? (l.getExpiresAt().isAfter(Instant.now()) ? "ACTIVE" : "EXPIRED")
                    : "REVOKED";
                return new TenantSummaryResponse.LicenseSummary(
                    l.getLicenseId(),
                    l.getPlan(),
                    status,
                    l.getExpiresAt(),
                    l.getMaxUsers(),
                    daysRemaining
                );
            }).orElse(null);

        return new TenantSummaryResponse(
            t.getId(),
            t.getTenantCode(),
            t.getCompanyName(),
            t.getCompanyNameNepali(),
            t.getStatus(),
            t.isSetupCompleted(),
            t.getSetupStep(),
            userCount,
            license,
            t.getCreatedAt(),
            t.getUpdatedAt()
        );
    }

    private void seedSystemAccounts(Long tenantId) {
        seedAccount(tenantId, "AR", "Accounts Receivable", AccountType.ASSET);
        seedAccount(tenantId, "AP", "Accounts Payable", AccountType.LIABILITY);
        seedAccount(tenantId, "INVENTORY_ASSET", "Inventory Asset", AccountType.ASSET);
        seedAccount(tenantId, "GST_OUTPUT", "GST Output Payable", AccountType.LIABILITY);
        seedAccount(tenantId, "GST_INPUT", "GST Input Credit", AccountType.ASSET);
        seedAccount(tenantId, "SALES", "Sales Revenue", AccountType.INCOME);
        seedAccount(tenantId, "SALES_RETURN", "Sales Returns", AccountType.INCOME);
        seedAccount(tenantId, "PURCHASE", "Purchase Expense", AccountType.EXPENSE);
        seedAccount(tenantId, "PURCHASE_RETURN", "Purchase Returns", AccountType.EXPENSE);
        seedAccount(tenantId, "COGS", "Cost of Goods Sold", AccountType.EXPENSE);
        seedAccount(tenantId, "INVENTORY_GAIN", "Inventory Adjustment Gain", AccountType.INCOME);
        seedAccount(tenantId, "INVENTORY_LOSS", "Inventory Adjustment Loss", AccountType.EXPENSE);
        seedAccount(tenantId, "BANK_CHARGES", "Bank Charges", AccountType.EXPENSE);
        seedAccount(tenantId, "INTEREST_INCOME", "Interest Income", AccountType.INCOME);
        seedAccount(tenantId, "SUSPENSE", "Suspense Account", AccountType.LIABILITY);
        seedAccount(tenantId, "CASH", "Cash", AccountType.ASSET);
        seedAccount(tenantId, "BANK", "Bank", AccountType.ASSET);
        seedAccount(tenantId, "FIXED_ASSETS", "Fixed Assets", AccountType.ASSET);
        seedAccount(tenantId, "INVESTMENTS", "Investments", AccountType.ASSET);
        seedAccount(tenantId, "OTHER_ASSETS", "Other Assets", AccountType.ASSET);
        seedAccount(tenantId, "BANK_LOANS", "Bank Loans", AccountType.LIABILITY);
        seedAccount(tenantId, "OTHER_LIABILITIES", "Other Liabilities", AccountType.LIABILITY);
        seedAccount(tenantId, "CAPITAL", "Owner's Capital", AccountType.EQUITY);
        seedAccount(tenantId, "RETAINED_EARNINGS", "Retained Earnings", AccountType.EQUITY);
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

    private String generateSecurePassword() {
        String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lower = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String symbols = "!@#$%&*";
        String all = upper + lower + digits + symbols;

        for (int attempt = 0; attempt < 10; attempt++) {
            StringBuilder sb = new StringBuilder(12);
            sb.append(upper.charAt(RNG.nextInt(upper.length())));
            sb.append(lower.charAt(RNG.nextInt(lower.length())));
            sb.append(digits.charAt(RNG.nextInt(digits.length())));
            sb.append(symbols.charAt(RNG.nextInt(symbols.length())));
            for (int i = 4; i < 12; i++) {
                sb.append(all.charAt(RNG.nextInt(all.length())));
            }
            char[] chars = sb.toString().toCharArray();
            for (int i = chars.length - 1; i > 0; i--) {
                int j = RNG.nextInt(i + 1);
                char tmp = chars[i]; chars[i] = chars[j]; chars[j] = tmp;
            }
            return new String(chars);
        }
        throw new IllegalStateException("Password generation failed");
    }
}
