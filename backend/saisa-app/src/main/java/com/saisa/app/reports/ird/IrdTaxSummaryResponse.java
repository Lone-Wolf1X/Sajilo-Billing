package com.saisa.app.reports.ird;

import java.math.BigDecimal;

public record IrdTaxSummaryResponse(
    BigDecimal totalSalesAmount,
    BigDecimal totalSalesTaxable,
    BigDecimal totalSalesNonTaxable,
    BigDecimal totalSalesVat,
    BigDecimal totalSalesExport,
    BigDecimal totalPurchaseAmount,
    BigDecimal totalPurchaseTaxable,
    BigDecimal totalPurchaseNonTaxable,
    BigDecimal totalPurchaseVat,
    BigDecimal totalPurchaseImport,
    BigDecimal netVatPayable,
    long salesCount,
    long purchaseCount
) {}

