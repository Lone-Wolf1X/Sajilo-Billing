package com.saisa.app.api.ledger;

import com.saisa.app.api.common.AuthenticatedUser;
import com.saisa.app.api.common.TenantGuard;
import com.saisa.financial.application.ledger.GeneralLedgerService;
import com.saisa.financial.application.ledger.LedgerEntry;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import java.time.LocalDate;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/ledger")
public class GeneralLedgerController {

    private final GeneralLedgerService glService;
    private final ChartOfAccountRepository accountRepo;

    public GeneralLedgerController(GeneralLedgerService glService,
                                   ChartOfAccountRepository accountRepo) {
        this.glService = glService;
        this.accountRepo = accountRepo;
    }

    @GetMapping("/{accountId}")
    public LedgerStatementResponse getStatement(
            @PathVariable Long accountId,
            @RequestParam LocalDate from,
            @RequestParam LocalDate to) {

        Long tenantId = AuthenticatedUser.tenantId();

        ChartOfAccount account = accountRepo.findById(accountId)
            .orElseThrow(() -> new InvalidJournalEntryException("Account not found"));
        TenantGuard.ensureOwned(account.getTenantId());

        List<LedgerEntry> entries = glService.getStatement(tenantId, accountId, from, to);
        return new LedgerStatementResponse(
            accountId, account.getAccountCode(), account.getAccountName(),
            from, to, entries);
    }

    public record LedgerStatementResponse(
        Long accountId, String accountCode, String accountName,
        LocalDate fromDate, LocalDate toDate,
        List<LedgerEntry> entries
    ) {}
}
