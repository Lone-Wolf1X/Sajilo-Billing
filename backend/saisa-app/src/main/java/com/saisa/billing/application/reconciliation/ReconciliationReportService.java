package com.saisa.billing.application.reconciliation;

import com.saisa.billing.domain.payment.Payment;
import com.saisa.billing.domain.payment.PaymentStatus;
import com.saisa.billing.domain.reconciliation.BankStatementLine;
import com.saisa.billing.domain.reconciliation.StatementLineStatus;
import com.saisa.billing.infrastructure.persistence.BankAccountRepository;
import com.saisa.billing.infrastructure.persistence.BankStatementLineRepository;
import com.saisa.billing.infrastructure.persistence.PaymentRepository;
import com.saisa.financial.application.ledger.AccountBalance;
import com.saisa.financial.application.ledger.GeneralLedgerService;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class ReconciliationReportService {

    private final BankAccountRepository bankRepo;
    private final BankStatementLineRepository lineRepo;
    private final PaymentRepository paymentRepo;
    private final GeneralLedgerService glService;

    public ReconciliationReportService(
            BankAccountRepository bankRepo,
            BankStatementLineRepository lineRepo,
            PaymentRepository paymentRepo,
            GeneralLedgerService glService) {
        this.bankRepo = bankRepo;
        this.lineRepo = lineRepo;
        this.paymentRepo = paymentRepo;
        this.glService = glService;
    }

    public record ReconciliationSummary(
        Long bankAccountId, String bankAccountName, LocalDate asOfDate,
        BigDecimal bookBalance,
        BigDecimal statementClosingBalance,
        BigDecimal unmatchedStatementTotal,
        BigDecimal unmatchedPaymentTotal,
        BigDecimal difference,
        boolean reconciled,
        List<BankStatementLine> unmatchedStatementLines
    ) {}

    public ReconciliationSummary generate(Long tenantId, Long bankAccountId, LocalDate asOfDate) {
        var bank = bankRepo.findById(bankAccountId)
            .orElseThrow(() -> new InvalidJournalEntryException("Bank not found"));
        if (!bank.getTenantId().equals(tenantId)) {
            throw new InvalidJournalEntryException("Bank not found");
        }

        // Book balance: current GL balance of the bank's GL account
        AccountBalance bal = glService.getBalance(
            tenantId, bank.getGlAccountId(),
            LocalDate.of(1900, 1, 1), asOfDate);
        BigDecimal bookBalance = bal.getNet().getAmount();

        // Statement closing balance: last line's running balance, or sum of movements
        List<BankStatementLine> allLines = lineRepo
            .findByTenantIdAndBankAccountIdOrderByStatementDate(tenantId, bankAccountId)
            .stream()
            .filter(l -> !l.getStatementDate().isAfter(asOfDate))
            .toList();

        BigDecimal statementClosing = BigDecimal.ZERO;
        if (!allLines.isEmpty()) {
            var last = allLines.get(allLines.size() - 1);
            statementClosing = last.getRunningBalance() != null
                ? last.getRunningBalance()
                : sumMovements(allLines);
        }

        // Unmatched statement lines (bank has them, we don't)
        List<BankStatementLine> unmatched = allLines.stream()
            .filter(l -> l.getStatus() == StatementLineStatus.UNMATCHED)
            .toList();
        BigDecimal unmatchedTotal = unmatched.stream()
            .map(l -> l.getCreditAmount().subtract(l.getDebitAmount()))
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Unmatched payments: POSTED payments on this bank, not matched to any line
        List<Payment> unmatchedPayments = paymentRepo.findAll().stream()
            .filter(p -> p.getTenantId().equals(tenantId))
            .filter(p -> p.getStatus() == PaymentStatus.POSTED)
            .filter(p -> p.getBankAccountId() != null
                && p.getBankAccountId().equals(bankAccountId))
            .filter(p -> !p.getPaymentDate().isAfter(asOfDate))
            .filter(p -> !isMatched(tenantId, p.getId()))
            .toList();

        BigDecimal unmatchedPaymentTotal = unmatchedPayments.stream()
            .map(p -> p.getPartyType().name().equals("CUSTOMER")
                ? p.getAmount()          // inflow
                : p.getAmount().negate()) // outflow
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal difference = bookBalance.subtract(statementClosing)
            .subtract(unmatchedTotal)
            .subtract(unmatchedPaymentTotal);

        boolean reconciled = difference.signum() == 0;

        return new ReconciliationSummary(
            bankAccountId, bank.getAccountName(), asOfDate,
            bookBalance, statementClosing,
            unmatchedTotal, unmatchedPaymentTotal,
            difference, reconciled, unmatched);
    }

    private boolean isMatched(Long tenantId, Long paymentId) {
        return lineRepo.existsByTenantIdAndMatchedPaymentIdAndStatus(
            tenantId, paymentId, StatementLineStatus.MATCHED);
    }

    private BigDecimal sumMovements(List<BankStatementLine> lines) {
        return lines.stream()
            .map(l -> l.getCreditAmount().subtract(l.getDebitAmount()))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}

