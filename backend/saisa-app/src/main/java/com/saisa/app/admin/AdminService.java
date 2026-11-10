package com.saisa.app.admin;

import com.saisa.app.admin.dto.OnboardTenantRequest;
import com.saisa.app.admin.dto.TenantSummaryResponse;
import com.saisa.billing.infrastructure.persistence.SalesInvoiceRepository;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.user.Role;
import com.saisa.common.user.RoleRepository;
import com.saisa.common.user.User;
import com.saisa.common.user.UserRepository;
import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import com.saisa.inventory.domain.warehouse.Warehouse;
import com.saisa.inventory.infrastructure.persistence.WarehouseRepository;
import java.util.List;
import java.util.Set;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminService {

    private final TenantRepository tenantRepo;
    private final UserRepository userRepo;
    private final RoleRepository roleRepo;
    private final ChartOfAccountRepository accountRepo;
    private final SalesInvoiceRepository invoiceRepo;
    private final WarehouseRepository warehouseRepo;
    private final PasswordEncoder passwordEncoder;

    public AdminService(TenantRepository tenantRepo,
                        UserRepository userRepo,
                        RoleRepository roleRepo,
                        ChartOfAccountRepository accountRepo,
                        SalesInvoiceRepository invoiceRepo,
                        WarehouseRepository warehouseRepo,
                        PasswordEncoder passwordEncoder) {
        this.tenantRepo = tenantRepo;
        this.userRepo = userRepo;
        this.roleRepo = roleRepo;
        this.accountRepo = accountRepo;
        this.invoiceRepo = invoiceRepo;
        this.warehouseRepo = warehouseRepo;
        this.passwordEncoder = passwordEncoder;
    }

    public List<TenantSummaryResponse> listTenants() {
        return tenantRepo.findAll().stream().map(t -> {
            long userCount = userRepo.countByTenantId(t.getId());
            long invoiceCount = invoiceRepo.countByTenantId(t.getId());
            return new TenantSummaryResponse(
                t.getId(),
                t.getTenantCode(),
                t.getCompanyName(),
                t.getCompanyNameNepali(),
                t.getPanVatNo(),
                t.getEmail(),
                t.getPhone(),
                t.getStatus(),
                t.isSetupCompleted(),
                t.getCreatedAt(),
                userCount,
                invoiceCount
            );
        }).toList();
    }

    @Transactional
    public TenantSummaryResponse onboardTenant(OnboardTenantRequest req) {
        String code = req.tenantCode().trim().toUpperCase();
        if (tenantRepo.existsByTenantCode(code)) {
            throw new IllegalArgumentException("Tenant Code '" + code + "' पहिले देखि दर्ता भइसकेको छ।");
        }

        Tenant tenant = new Tenant();
        tenant.setTenantCode(code);
        tenant.setCompanyName(req.companyName().trim());
        tenant.setCompanyNameNepali(req.companyNameNepali() != null ? req.companyNameNepali().trim() : null);
        tenant.setPanVatNo(req.panVatNo() != null ? req.panVatNo().trim() : null);
        tenant.setPhone(req.phone());
        tenant.setEmail(req.email());
        tenant.setProvince(req.province());
        tenant.setDistrict(req.district());
        tenant.setAddress(req.address());
        tenant.setStatus("ACTIVE");
        tenant = tenantRepo.save(tenant);

        // Seed system accounts
        seedSystemAccounts(tenant.getId());

        // Create default warehouse
        Warehouse wh = new Warehouse();
        wh.setTenantId(tenant.getId());
        wh.setCode("MAIN");
        wh.setName("Main Godown / मुख्य गोदाम");
        wh.setDefaultWarehouse(true);
        wh.setActive(true);
        warehouseRepo.save(wh);

        // Create Admin user
        Role adminRole = roleRepo.findByRoleCode("ADMIN")
            .orElseGet(() -> {
                Role r = new Role();
                r.setRoleCode("ADMIN");
                r.setRoleName("Administrator");
                return roleRepo.save(r);
            });

        User admin = new User();
        admin.setTenantId(tenant.getId());
        admin.setUsername(req.adminUsername().trim());
        admin.setEmail(req.adminEmail().trim());
        admin.setPasswordHash(passwordEncoder.encode(req.adminPassword().trim()));
        admin.setFullName(req.adminFullName().trim());
        admin.setRoles(Set.of(adminRole));
        userRepo.save(admin);

        return new TenantSummaryResponse(
            tenant.getId(),
            tenant.getTenantCode(),
            tenant.getCompanyName(),
            tenant.getCompanyNameNepali(),
            tenant.getPanVatNo(),
            tenant.getEmail(),
            tenant.getPhone(),
            tenant.getStatus(),
            tenant.isSetupCompleted(),
            tenant.getCreatedAt(),
            1L,
            0L
        );
    }

    @Transactional
    public TenantSummaryResponse toggleStatus(Long id, String status) {
        Tenant tenant = tenantRepo.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Tenant not found"));
        tenant.setStatus(status.toUpperCase());
        tenantRepo.save(tenant);
        return new TenantSummaryResponse(
            tenant.getId(),
            tenant.getTenantCode(),
            tenant.getCompanyName(),
            tenant.getCompanyNameNepali(),
            tenant.getPanVatNo(),
            tenant.getEmail(),
            tenant.getPhone(),
            tenant.getStatus(),
            tenant.isSetupCompleted(),
            tenant.getCreatedAt(),
            userRepo.countByTenantId(tenant.getId()),
            invoiceRepo.countByTenantId(tenant.getId())
        );
    }

    private void seedSystemAccounts(Long tenantId) {
        seedAccount(tenantId, "AR", "Accounts Receivable", AccountType.ASSET);
        seedAccount(tenantId, "AP", "Accounts Payable", AccountType.LIABILITY);
        seedAccount(tenantId, "INVENTORY_ASSET", "Inventory Asset", AccountType.ASSET);
        seedAccount(tenantId, "GST_OUTPUT", "VAT Output Payable", AccountType.LIABILITY);
        seedAccount(tenantId, "GST_INPUT", "VAT Input Credit", AccountType.ASSET);
        seedAccount(tenantId, "SALES", "Sales Revenue", AccountType.INCOME);
        seedAccount(tenantId, "SALES_RETURN", "Sales Returns", AccountType.INCOME);
        seedAccount(tenantId, "PURCHASE", "Cost of Goods Sold (Purchase)", AccountType.EXPENSE);
        seedAccount(tenantId, "PURCHASE_RETURN", "Purchase Returns", AccountType.EXPENSE);
        seedAccount(tenantId, "BANK_DEFAULT", "Primary Bank Account", AccountType.ASSET);
        seedAccount(tenantId, "CASH_IN_HAND", "Cash in Hand", AccountType.ASSET);
        seedAccount(tenantId, "CAPITAL", "Owner's Capital", AccountType.EQUITY);
    }

    private void seedAccount(Long tenantId, String code, String name, AccountType type) {
        if (!accountRepo.existsByTenantIdAndAccountCode(tenantId, code)) {
            ChartOfAccount acc = new ChartOfAccount();
            acc.setTenantId(tenantId);
            acc.setAccountCode(code);
            acc.setAccountName(name);
            acc.setAccountType(type);
            acc.setSystemAccount(true);
            acc.setActive(true);
            accountRepo.save(acc);
        }
    }
}
