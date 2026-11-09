package com.saisa.common.tenant.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public record OpeningStockResponse(
    boolean posted,
    Long journalEntryId,
    String journalEntryNumber,
    LocalDate openingDate,
    Long warehouseId,
    int itemCount,
    BigDecimal totalQuantity,
    BigDecimal totalValue
) {}

