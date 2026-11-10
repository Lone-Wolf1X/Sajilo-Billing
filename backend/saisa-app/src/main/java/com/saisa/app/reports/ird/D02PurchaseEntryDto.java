package com.saisa.app.reports.ird;

import java.math.BigDecimal;
import java.time.LocalDate;

public record D02PurchaseEntryDto(
    Long id,
    LocalDate dateAd,
    String dateBs,
    String invoiceNumber,
    String supplierName,
    String supplierPan,
    BigDecimal totalAmount,
    BigDecimal nonTaxableAmount,
    BigDecimal taxableAmount,
    BigDecimal vatAmount,
    BigDecimal importAmount
) {}

