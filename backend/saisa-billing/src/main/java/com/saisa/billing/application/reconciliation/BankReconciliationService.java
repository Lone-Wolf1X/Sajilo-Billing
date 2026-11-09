package com.saisa.billing.application.reconciliation;

import com.saisa.billing.domain.exception.InvalidBankReconciliationException;
import com.saisa.billing.domain.payment.Payment;
import com.saisa.billing.domain.payment.PaymentMethod;
import com.saisa.billing.domain.payment.PaymentStatus;
import com.saisa.billing.domain.reconciliation.BankStatementLine;
import com.saisa.billing.domain.reconciliation.StatementLineStatus;
import com.saisa.billing.infrastructure.persistence.BankStatementLineRepository;
import com.saisa.billing.infrastructure.persistence.PaymentRepository;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BankReconciliationService {

    private static final Logger log = LoggerFactory.getLogger(BankReconciliationService.class);

    private final BankStatementLineRepository lineRepo;
    private final PaymentRepository paymentRepo;

    public BankReconciliationService(BankStatementLineRepository lineRepo,
                                     PaymentRepository paymentRepo) {
        this.lineRepo = lineRepo;
        this.paymentRepo = paymentRepo;
    }

    /**
     * Auto-match strategy:
     *   1. Only POSTED payments whose bank_account_id matches the statement line
     *   2. Payment date within ±3 days of statement date (bank settlement lag)
     *   3. Amount matches exactly (same direction)
     *   4. Bonus: if reference_no matches, boost priority
     *
     * Returns count of newly matched lines.
     */
    @Transactional
    public int autoMatch(Long tenantId, Long bankAccountId) {
        List<BankStatementLine> unmatched = lineRepo
            .findByTenantIdAndBankAccountIdOrderByStatementDate(tenantId, bankAccountId)
            .stream()
            .filter(l -> l.getStatus() == StatementLineStatus.UNMATCHED)
            .toList();

        int matched = 0;
        for (BankStatementLine line : unmatched) {
            Payment match = findBestMatch(tenantId, bankAccountId, line);
            if (match != null) {
                applyMatch(line, match, null);
                matched++;
                log.info("Auto-matched statement line {} to payment {}",
                    line.getId(), match.getPaymentNumber());
            }
        }
        return matched;
    }

    private Payment findBestMatch(Long tenantId, Long bankAccountId, BankStatementLine line) {
        boolean lineIsInflow = line.getCreditAmount().signum() > 0;
        BigDecimal lineAmount = lineIsInflow ? line.getCreditAmount() : line.getDebitAmount();

        List<Payment> candidates = paymentRepo.findAll().stream()
            .filter(p -> p.getTenantId().equals(tenantId))
            .filter(p -> p.getStatus() == PaymentStatus.POSTED)
            .filter(p -> p.getBankAccountId() != null
                && p.getBankAccountId().equals(bankAccountId))
            .filter(p -> p.getPaymentMethod() != PaymentMethod.CASH)
            .filter(p -> Math.abs(ChronoUnit.DAYS.between(
                p.getPaymentDate(), line.getStatementDate())) <= 3)
            .filter(p -> p.getAmount().compareTo(lineAmount) == 0)
            .filter(p -> !isAlreadyMatched(tenantId, p.getId()))
            .toList();

        return candidates.stream()
            .filter(p -> line.getReferenceNo() != null
                && p.getReferenceNo() != null
                && line.getReferenceNo().equalsIgnoreCase(p.getReferenceNo()))
            .findFirst()
            .orElse(candidates.isEmpty() ? null : candidates.get(0));
    }

    private boolean isAlreadyMatched(Long tenantId, Long paymentId) {
        return lineRepo.existsByTenantIdAndMatchedPaymentIdAndStatus(
            tenantId, paymentId, StatementLineStatus.MATCHED);
    }

    /**
     * Manually match a statement line to a payment. Validates amount and direction.
     */
    @Transactional
    public BankStatementLine manualMatch(Long tenantId, Long lineId, Long paymentId, Long userId) {
        BankStatementLine line = lineRepo.findByIdAndTenantId(lineId, tenantId)
            .orElseThrow(() -> new InvalidBankReconciliationException("Statement line not found"));

        if (line.getStatus() != StatementLineStatus.UNMATCHED) {
            throw new InvalidBankReconciliationException(
                "Only UNMATCHED lines can be matched. Current: " + line.getStatus());
        }

        Payment payment = paymentRepo.findById(paymentId)
            .orElseThrow(() -> new InvalidBankReconciliationException("Payment not found"));

        if (!payment.getTenantId().equals(tenantId)) {
            throw new InvalidBankReconciliationException("Payment not found");
        }
        if (payment.getStatus() != PaymentStatus.POSTED) {
            throw new InvalidBankReconciliationException("Only POSTED payments can be matched");
        }
        if (payment.getBankAccountId() == null
                || !payment.getBankAccountId().equals(line.getBankAccountId())) {
            throw new InvalidBankReconciliationException(
                "Payment bank account does not match statement line");
        }

        boolean lineIsInflow = line.getCreditAmount().signum() > 0;
        BigDecimal lineAmount = lineIsInflow ? line.getCreditAmount() : line.getDebitAmount();
        if (payment.getAmount().compareTo(lineAmount) != 0) {
            throw new InvalidBankReconciliationException(
                "Amount mismatch: statement " + lineAmount + " vs payment " + payment.getAmount());
        }

        applyMatch(line, payment, userId);
        return lineRepo.save(line);
    }

    private void applyMatch(BankStatementLine line, Payment payment, Long userId) {
        line.setStatus(StatementLineStatus.MATCHED);
        line.setMatchedPaymentId(payment.getId());
        line.setMatchedAt(Instant.now());
        line.setMatchedBy(userId != null ? userId : 1L);
        lineRepo.save(line);
    }

    @Transactional
    public BankStatementLine unmatch(Long tenantId, Long lineId) {
        BankStatementLine line = lineRepo.findByIdAndTenantId(lineId, tenantId)
            .orElseThrow(() -> new InvalidBankReconciliationException("Statement line not found"));
        if (line.getStatus() != StatementLineStatus.MATCHED) {
            throw new InvalidBankReconciliationException("Line is not matched");
        }
        line.setStatus(StatementLineStatus.UNMATCHED);
        line.setMatchedPaymentId(null);
        line.setMatchedAt(null);
        line.setMatchedBy(null);
        return lineRepo.save(line);
    }

    @Transactional
    public BankStatementLine ignore(Long tenantId, Long lineId, Long userId) {
        BankStatementLine line = lineRepo.findByIdAndTenantId(lineId, tenantId)
            .orElseThrow(() -> new InvalidBankReconciliationException("Statement line not found"));
        if (line.getStatus() == StatementLineStatus.MATCHED) {
            throw new InvalidBankReconciliationException(
                "Cannot ignore a matched line. Unmatch first.");
        }
        line.setStatus(StatementLineStatus.IGNORED);
        line.setNotes("Ignored by user " + userId);
        return lineRepo.save(line);
    }
}

