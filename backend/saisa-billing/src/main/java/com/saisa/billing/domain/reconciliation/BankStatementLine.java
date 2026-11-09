package com.saisa.billing.domain.reconciliation;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "bank_statement_lines")
@Getter
@Setter
public class BankStatementLine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "bank_account_id", nullable = false)
    private Long bankAccountId;

    @Column(name = "statement_date", nullable = false)
    private LocalDate statementDate;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "reference_no", length = 128)
    private String referenceNo;

    @Column(name = "debit_amount", nullable = false, precision = 20, scale = 4)
    private BigDecimal debitAmount = BigDecimal.ZERO;

    @Column(name = "credit_amount", nullable = false, precision = 20, scale = 4)
    private BigDecimal creditAmount = BigDecimal.ZERO;

    @Column(name = "running_balance", precision = 20, scale = 4)
    private BigDecimal runningBalance;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 16)
    private StatementLineStatus status = StatementLineStatus.UNMATCHED;

    @Column(name = "matched_payment_id")
    private Long matchedPaymentId;

    @Column(name = "matched_at")
    private Instant matchedAt;

    @Column(name = "matched_by")
    private Long matchedBy;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "created_by")
    private Long createdBy;
}
