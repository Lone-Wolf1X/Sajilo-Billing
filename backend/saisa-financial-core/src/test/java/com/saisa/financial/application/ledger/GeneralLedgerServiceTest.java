package com.saisa.financial.application.ledger;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.application.posting.TestApplication;
import com.saisa.financial.application.reporting.TrialBalanceService;
import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import java.time.LocalDate;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest(classes = TestApplication.class)
@ActiveProfiles("test")
@Transactional
class GeneralLedgerServiceTest {

    @Autowired private GeneralLedgerService glService;
    @Autowired private TrialBalanceService tbService;
    @Autowired private JournalPostingService postingService;
    @Autowired private ChartOfAccountRepository accountRepo;
    @Autowired private AccountingPeriodRepository periodRepo;

    private Long tenantId = 200L;
    private Long cashAccountId;
    private Long salesAccountId;
    private Long rentAccountId;
    private Long periodId;

    @BeforeEach
    void setUp() {
        cashAccountId = createAccount("1001", "Cash", AccountType.ASSET);
        salesAccountId = createAccount("4001", "Sales", AccountType.INCOME);
        rentAccountId = createAccount("5001", "Rent Expense", AccountType.EXPENSE);

        AccountingPeriod period = new AccountingPeriod();
        period.setTenantId(tenantId);
        period.setPeriodName("Apr-2026");
        period.setStartDate(LocalDate.of(2026, 4, 1));
        period.setEndDate(LocalDate.of(2026, 4, 30));
        period = periodRepo.save(period);
        periodId = period.getId();
    }

    private Long createAccount(String code, String name, AccountType type) {
        ChartOfAccount a = new ChartOfAccount();
        a.setTenantId(tenantId);
        a.setAccountCode(code);
        a.setAccountName(name);
        a.setAccountType(type);
        return accountRepo.save(a).getId();
    }

    @Test
    void generalLedgerShowsRunningBalanceInNormalDirection() {
        // Opening: Cash Dr 10,000 / Sales Cr 10,000
        post(LocalDate.of(2026, 4, 1), cashAccountId, salesAccountId,
            "10000.00", "Opening sale");

        // Second sale: Cash Dr 3,000 / Sales Cr 3,000
        post(LocalDate.of(2026, 4, 5), cashAccountId, salesAccountId,
            "3000.00", "Sale to Ramesh");

        // Rent paid: Rent Dr 2,000 / Cash Cr 2,000
        post(LocalDate.of(2026, 4, 10), rentAccountId, cashAccountId,
            "2000.00", "Rent");

        List<LedgerEntry> cashGl = glService.getStatement(
            tenantId, cashAccountId,
            LocalDate.of(2026, 4, 1), LocalDate.of(2026, 4, 30));

        assertEquals(3, cashGl.size());
        assertEquals(Money.ofInr("10000.00"), cashGl.get(0).runningBalance());
        assertEquals(Money.ofInr("13000.00"), cashGl.get(1).runningBalance());
        assertEquals(Money.ofInr("11000.00"), cashGl.get(2).runningBalance());
    }

    @Test
    void trialBalanceIsBalanced() {
        post(LocalDate.of(2026, 4, 1), cashAccountId, salesAccountId,
            "10000.00", "Sale");
        post(LocalDate.of(2026, 4, 10), rentAccountId, cashAccountId,
            "2000.00", "Rent");

        var rows = tbService.computeTrialBalance(tenantId, LocalDate.of(2026, 4, 30));

        assertTrue(tbService.isBalanced(rows),
            "Trial balance must sum debits == credits");
        assertEquals(3, rows.size()); // Cash, Sales, Rent

        // Cash: 10000 Dr - 2000 Cr = 8000 Dr
        var cashRow = rows.stream()
            .filter(r -> r.accountId().equals(cashAccountId)).findFirst().orElseThrow();
        assertEquals(0, cashRow.debitBalance().compareTo(new java.math.BigDecimal("8000.0000")));
        assertEquals(0, cashRow.creditBalance().compareTo(java.math.BigDecimal.ZERO));

        // Sales: 10000 Cr
        var salesRow = rows.stream()
            .filter(r -> r.accountId().equals(salesAccountId)).findFirst().orElseThrow();
        assertEquals(0, salesRow.debitBalance().compareTo(java.math.BigDecimal.ZERO));
        assertEquals(0, salesRow.creditBalance().compareTo(new java.math.BigDecimal("10000.0000")));

        // Rent: 2000 Dr
        var rentRow = rows.stream()
            .filter(r -> r.accountId().equals(rentAccountId)).findFirst().orElseThrow();
        assertEquals(0, rentRow.debitBalance().compareTo(new java.math.BigDecimal("2000.0000")));
    }

    private void post(LocalDate date, Long debitAcc, Long creditAcc,
                      String amount, String narration) {
        postingService.post(
            JournalEntryBuilder.create()
                .tenant(tenantId)
                .entryDate(date)
                .period(periodId)
                .type(EntryType.MANUAL)
                .description(narration)
                .debit(debitAcc, Money.ofInr(amount))
                .credit(creditAcc, Money.ofInr(amount))
                .build(),
            1L);
    }
}
