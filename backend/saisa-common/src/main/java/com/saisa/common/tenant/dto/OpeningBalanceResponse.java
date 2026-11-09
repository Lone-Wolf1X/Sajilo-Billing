package com.saisa.common.tenant.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public record OpeningBalanceResponse(
    boolean posted,
    Long journalEntryId,
    String journalEntryNumber,
    LocalDate openingDate,
    BigDecimal totalDebits,
    BigDecimal totalCredits,
    BigDecimal totalAssets,
    BigDecimal totalLiabilities,
    BigDecimal totalEquity,
    boolean balanced
) {}

