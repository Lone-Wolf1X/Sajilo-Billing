package com.saisa.billing.api.payment;

import com.saisa.billing.domain.payment.BankAccount;
import com.saisa.billing.infrastructure.persistence.BankAccountRepository;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/bank-accounts")
public class BankAccountController {

    private final BankAccountRepository bankRepo;

    public BankAccountController(BankAccountRepository bankRepo) {
        this.bankRepo = bankRepo;
    }

    public record CreateBankAccountRequest(
        @NotBlank String accountCode,
        @NotBlank String accountName,
        String bankName,
        String accountNumber,
        String ifscCode,
        @NotNull Long glAccountId,
        Boolean isDefault
    ) {}

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<BankAccount> create(@Valid @RequestBody CreateBankAccountRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        if (bankRepo.findByTenantIdAndAccountCode(tenantId, req.accountCode()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Bank account code already exists");
        }

        BankAccount ba = new BankAccount();
        ba.setTenantId(tenantId);
        ba.setAccountCode(req.accountCode());
        ba.setAccountName(req.accountName());
        ba.setBankName(req.bankName());
        ba.setAccountNumber(req.accountNumber());
        ba.setIfscCode(req.ifscCode());
        ba.setGlAccountId(req.glAccountId());
        if (req.isDefault() != null) {
            ba.setDefaultAccount(req.isDefault());
        }
        ba.setActive(true);
        ba.setCreatedBy(userId);

        BankAccount saved = bankRepo.save(ba);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping
    public List<BankAccount> list() {
        return bankRepo.findByTenantIdAndActiveTrueOrderByAccountCode(
            TenantContext.getCurrentTenantId());
    }
}

