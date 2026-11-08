package com.saisa.financial.application.posting;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.saisa.financial.application.reversal.ReversalService;
import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
import com.saisa.financial.infrastructure.persistence.JournalEntryRepository;
import java.math.BigDecimal;
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
class JournalPostingServiceTest {

    @Autowired private JournalPostingService postingService;
    @Autowired private ReversalService reversalService;
    @Autowired private JournalEntryRepository journalRepo;
    @Autowired private ChartOfAccountRepository accountRepo;
    @Autowired private AccountingPeriodRepository periodRepo;

    private Long tenantId = 100L;
    private Long cashAccountId;
    private Long salesAccountId;
    private Long periodId;

    @BeforeEach
    void setUp() {
        ChartOfAccount cash = new ChartOfAccount();
        cash.setTenantId(tenantId);
        cash.setAccountCode("1001");
        cash.setAccountName("Cash");
        cash.setAccountType(AccountType.ASSET);
        cash = accountRepo.save(cash);
        cashAccountId = cash.getId();

        ChartOfAccount sales = new ChartOfAccount();
        sales.setTenantId(tenantId);
        sales.setAccountCode("4001");
        sales.setAccountName("Sales");
        sales.setAccountType(AccountType.INCOME);
        sales = accountRepo.save(sales);
        salesAccountId = sales.getId();

        AccountingPeriod period = new AccountingPeriod();
        period.setTenantId(tenantId);
        period.setPeriodName("Apr-2026");
        period.setStartDate(LocalDate.of(2026, 4, 1));
        period.setEndDate(LocalDate.of(2026, 4, 30));
        period = periodRepo.save(period);
        periodId = period.getId();
    }

    @Test
    void postsBalancedEntryAndMarksPosted() {
        JournalEntry draft = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(LocalDate.of(2026, 4, 15))
            .period(periodId)
            .type(EntryType.SALES)
            .description("Test sale")
            .debit(cashAccountId, Money.ofInr("1000.00"))
            .credit(salesAccountId, Money.ofInr("1000.00"))
            .build();

        JournalEntry posted = postingService.post(draft, 1L);

        assertNotNull(posted.getId());
        assertEquals(EntryStatus.POSTED, posted.getStatus());
        assertNotNull(posted.getPostedAt());
        assertEquals(2, posted.getLines().size());
    }

    @Test
    void rejectsUnbalancedEntry() {
        assertThrows(InvalidJournalEntryException.class, () ->
            JournalEntryBuilder.create()
                .tenant(tenantId)
                .entryDate(LocalDate.of(2026, 4, 15))
                .period(periodId)
                .type(EntryType.MANUAL)
                .debit(cashAccountId, Money.ofInr("1000.00"))
                .credit(salesAccountId, Money.ofInr("900.00"))
                .build()
        );
    }

    @Test
    void idempotentReplayReturnsSameEntry() {
        String key = "test-idem-001";
        JournalEntry draft = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(LocalDate.of(2026, 4, 15))
            .period(periodId)
            .type(EntryType.MANUAL)
            .idempotencyKey(key)
            .debit(cashAccountId, Money.ofInr("500.00"))
            .credit(salesAccountId, Money.ofInr("500.00"))
            .build();

        JournalEntry first = postingService.post(draft, 1L);

        JournalEntry draft2 = JournalEntryBuilder.create()
            .tenant(tenantId)
            .entryDate(LocalDate.of(2026, 4, 15))
            .period(periodId)
            .type(EntryType.MANUAL)
            .idempotencyKey(key)
            .debit(cashAccountId, Money.ofInr("500.00"))
            .credit(salesAccountId, Money.ofInr("500.00"))
            .build();

        JournalEntry second = postingService.post(draft2, 1L);

        assertEquals(first.getId(), second.getId());
        assertEquals(1, journalRepo.count());
    }

    @Test
    void reversalCreatesMirrorEntry() {
        JournalEntry original = postingService.post(
            JournalEntryBuilder.create()
                .tenant(tenantId)
                .entryDate(LocalDate.of(2026, 4, 15))
                .period(periodId)
                .type(EntryType.SALES)
                .debit(cashAccountId, Money.ofInr("1000.00"))
                .credit(salesAccountId, Money.ofInr("1000.00"))
                .build(),
            1L);

        JournalEntry reversal = reversalService.reverse(
            original.getId(), LocalDate.of(2026, 4, 20), "Test correction", 1L);

        assertEquals(EntryType.REVERSAL, reversal.getEntryType());
        assertEquals(original.getId(), reversal.getReversalOfId());
        assertEquals(EntryStatus.POSTED, reversal.getStatus());

        // Original should be marked REVERSED.
        JournalEntry reloaded = journalRepo.findById(original.getId()).orElseThrow();
        assertEquals(EntryStatus.REVERSED, reloaded.getStatus());

        // Mirror check: reversal has credit to cash and debit to sales.
        boolean hasCashCredit = reversal.getLines().stream().anyMatch(l ->
            l.getAccountId().equals(cashAccountId)
                && l.getCreditAmount().compareTo(new BigDecimal("1000.0000")) == 0);
        assertTrue(hasCashCredit, "Reversal must have a credit to Cash");
    }
}

