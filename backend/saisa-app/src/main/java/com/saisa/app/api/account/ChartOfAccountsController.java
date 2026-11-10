package com.saisa.app.api.account;

import com.saisa.app.api.common.AuthenticatedUser;
import com.saisa.app.api.common.TenantGuard;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/accounts")
@PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT', 'VIEWER')")
public class ChartOfAccountsController {

    private final ChartOfAccountRepository accountRepo;

    public ChartOfAccountsController(ChartOfAccountRepository accountRepo) {
        this.accountRepo = accountRepo;
    }

    @GetMapping
    public List<AccountResponse> list() {
        Long tenantId = AuthenticatedUser.tenantId();
        return accountRepo.findByTenantIdOrderByAccountCode(tenantId)
            .stream().map(AccountResponse::from).toList();
    }

    @GetMapping("/{id}")
    public AccountResponse get(@PathVariable Long id) {
        ChartOfAccount a = accountRepo.findById(id)
            .orElseThrow(() -> new InvalidJournalEntryException("Account not found: " + id));
        TenantGuard.ensureOwned(a.getTenantId());
        return AccountResponse.from(a);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<AccountResponse> create(@Valid @RequestBody CreateAccountRequest req) {
        Long tenantId = AuthenticatedUser.tenantId();

        if (accountRepo.existsByTenantIdAndAccountCode(tenantId, req.accountCode())) {
            throw new InvalidJournalEntryException(
                "Account code already exists: " + req.accountCode());
        }

        if (req.parentAccountId() != null) {
            ChartOfAccount parent = accountRepo.findById(req.parentAccountId())
                .orElseThrow(() -> new InvalidJournalEntryException(
                    "Parent account not found: " + req.parentAccountId()));
            TenantGuard.ensureOwned(parent.getTenantId());
        }

        ChartOfAccount a = new ChartOfAccount();
        a.setTenantId(tenantId);  // ALWAYS from context, never from request
        a.setAccountCode(req.accountCode());
        a.setAccountName(req.accountName());
        a.setAccountType(req.accountType());
        a.setParentAccountId(req.parentAccountId());
        a.setCreatedBy(AuthenticatedUser.userId());

        ChartOfAccount saved = accountRepo.save(a);
        return ResponseEntity.status(HttpStatus.CREATED).body(AccountResponse.from(saved));
    }
}
