package com.saisa.billing.api.reconciliation;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public record CreateStatementLineRequest(
    @NotNull Long bankAccountId,
    @NotNull LocalDate statementDate,
    String description,
    String referenceNo,
    String debitAmount,
    String creditAmount,
    String runningBalance
) {}
