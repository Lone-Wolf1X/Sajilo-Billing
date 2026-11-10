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
        Boolean isDefault,
        Boolean defaultAccount
    ) {
        public boolean isEffectiveDefault() {
            if (isDefault != null) return isDefault;
            if (defaultAccount != null) return defaultAccount;
            return false;
        }
    }

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
        ba.setDefaultAccount(req.isEffectiveDefault());
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

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<BankAccount> update(
            @PathVariable Long id,
            @RequestBody java.util.Map<String, Object> body) {
        Long tenantId = TenantContext.getCurrentTenantId();

        BankAccount ba = bankRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Bank account not found"));
        if (!ba.getTenantId().equals(tenantId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Bank account not found");
        }

        if (body.get("accountName") != null) ba.setAccountName((String) body.get("accountName"));
        if (body.get("bankName") != null) ba.setBankName((String) body.get("bankName"));
        if (body.get("accountNumber") != null) ba.setAccountNumber((String) body.get("accountNumber"));
        if (body.get("ifscCode") != null) ba.setIfscCode((String) body.get("ifscCode"));
        if (body.get("glAccountId") != null) {
            ba.setGlAccountId(((Number) body.get("glAccountId")).longValue());
        }
        if (body.get("defaultAccount") != null) {
            ba.setDefaultAccount((Boolean) body.get("defaultAccount"));
        } else if (body.get("isDefault") != null) {
            ba.setDefaultAccount((Boolean) body.get("isDefault"));
        }
        if (body.get("active") != null) {
            ba.setActive((Boolean) body.get("active"));
        }
        ba.setUpdatedBy(TenantContext.getCurrentUserId());

        return ResponseEntity.ok(bankRepo.save(ba));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        Long tenantId = TenantContext.getCurrentTenantId();

        BankAccount ba = bankRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Bank account not found"));
        if (!ba.getTenantId().equals(tenantId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Bank account not found");
        }

        ba.setActive(false);
        ba.setUpdatedBy(TenantContext.getCurrentUserId());
        bankRepo.save(ba);

        return ResponseEntity.noContent().build();
    }
}

