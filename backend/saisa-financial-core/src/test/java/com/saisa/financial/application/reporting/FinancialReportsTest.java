package com.saisa.financial.application.reporting;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.application.posting.TestApplication;
import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import java.time.LocalDate;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest(classes = TestApplication.class)
@ActiveProfiles("test")
@Transactional
class FinancialReportsTest {

    @Autowired private ProfitAndLossService plService;
    @Autowired private BalanceSheetService bsService;
    @Autowired private CashFlowService cfService;
    @Autowired private JournalPostingService postingService;
    @Autowired private ChartOfAccountRepository accountRepo;
    @Autowired private AccountingPeriodRepository periodRepo;

    private Long tenantId = 300L;
    private Long cashId, capitalId, salesId, rentId;
    private Long periodId;

    @BeforeEach
    void setUp() {
        cashId    = create("1001", "Cash",         AccountType.ASSET);
        capitalId = create("3001", "Capital",      AccountType.EQUITY);
        salesId   = create("4001", "Sales",        AccountType.INCOME);
        rentId    = create("5001", "Rent Expense", AccountType.EXPENSE);

        AccountingPeriod p = new AccountingPeriod();
        p.setTenantId(tenantId);
        p.setPeriodName("Apr-2026");
        p.setStartDate(LocalDate.of(2026, 4, 1));
        p.setEndDate(LocalDate.of(2026, 4, 30));
        periodId = periodRepo.save(p).getId();
    }

    private Long create(String code, String name, AccountType t) {
        ChartOfAccount a = new ChartOfAccount();
        a.setTenantId(tenantId);
        a.setAccountCode(code);
        a.setAccountName(name);
        a.setAccountType(t);
        return accountRepo.save(a).getId();
    }

    private void post(LocalDate d, EntryType type, Long drAcc, Long crAcc, String amt) {
        postingService.post(
            JournalEntryBuilder.create()
                .tenant(tenantId).entryDate(d).period(periodId).type(type)
                .debit(drAcc, Money.ofInr(amt)).credit(crAcc, Money.ofInr(amt))
                .build(), 1L);
    }

    @Test
    void profitAndLossShowsRevenueMinusExpenses() {
        // Owner invests 50,000
        post(LocalDate.of(2026,4,1), EntryType.OPENING, cashId, capitalId, "50000.00");
        // Sales 30,000
        post(LocalDate.of(2026,4,5), EntryType.SALES,   cashId, salesId,   "30000.00");
        // Rent 8,000
        post(LocalDate.of(2026,4,10), EntryType.PAYMENT, rentId, cashId,   "8000.00");

        var pl = plService.generate(tenantId,
            LocalDate.of(2026,4,1), LocalDate.of(2026,4,30));

        assertEquals(Money.ofInr("30000.00"), pl.totalRevenue());
        assertEquals(Money.ofInr("8000.00"),  pl.totalExpenses());
        assertEquals(Money.ofInr("22000.00"), pl.netProfit());
        assertTrue(pl.isProfitable());
    }

    @Test
    void balanceSheetBalancesWithCurrentEarnings() {
        post(LocalDate.of(2026,4,1), EntryType.OPENING, cashId, capitalId, "50000.00");
        post(LocalDate.of(2026,4,5), EntryType.SALES,   cashId, salesId,   "30000.00");
        post(LocalDate.of(2026,4,10), EntryType.PAYMENT, rentId, cashId,   "8000.00");

        var bs = bsService.generate(tenantId, LocalDate.of(2026,4,30));

        // Assets: Cash = 50k + 30k - 8k = 72,000
        assertEquals(Money.ofInr("72000.00"), bs.totalAssets());
        // Equity: Capital 50k
        assertEquals(Money.ofInr("50000.00"), bs.totalEquity());
        // Current earnings: 30k - 8k = 22k
        assertEquals(Money.ofInr("22000.00"), bs.currentEarnings());
        // Liabilities + Equity + Earnings = 0 + 50k + 22k = 72k
        assertEquals(Money.ofInr("72000.00"), bs.totalLiabilitiesAndEquity());
        // Golden equation holds
        assertTrue(bs.balanced());
    }

    @Test
    void cashFlowTracksOpeningAndClosingBalances() {
        post(LocalDate.of(2026,4,1), EntryType.OPENING, cashId, capitalId, "50000.00");
        post(LocalDate.of(2026,4,5), EntryType.SALES,   cashId, salesId,   "30000.00");
        post(LocalDate.of(2026,4,10), EntryType.PAYMENT, rentId, cashId,   "8000.00");

        var cf = cfService.generate(tenantId,
            LocalDate.of(2026,4,1), LocalDate.of(2026,4,30));

        assertEquals(Money.ofInr("0.00"),     cf.openingBalance());
        // Net change: +50k +30k -8k = +72k
        assertEquals(Money.ofInr("72000.00"), cf.netChange());
        assertEquals(Money.ofInr("72000.00"), cf.closingBalance());
    }

    @Test
    void reportsHandleEmptyTenant() {
        var pl = plService.generate(999L,
            LocalDate.of(2026,4,1), LocalDate.of(2026,4,30));
        assertTrue(pl.revenueLines().isEmpty());
        assertTrue(pl.expenseLines().isEmpty());
        assertEquals(Money.ofInr("0.00"), pl.netProfit());
        assertFalse(pl.isProfitable());
    }
}
