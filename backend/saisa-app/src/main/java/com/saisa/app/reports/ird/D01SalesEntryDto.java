package com.saisa.app.reports.ird;

import java.math.BigDecimal;
import java.time.LocalDate;

public record D01SalesEntryDto(
    Long id,
    LocalDate dateAd,
    String dateBs,
    String invoiceNumber,
    String customerName,
    String customerPan,
    BigDecimal totalAmount,
    BigDecimal nonTaxableAmount,
    BigDecimal taxableAmount,
    BigDecimal vatAmount,
    BigDecimal exportAmount
) {}
