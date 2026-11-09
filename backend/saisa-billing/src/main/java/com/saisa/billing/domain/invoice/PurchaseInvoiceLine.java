package com.saisa.billing.domain.invoice;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "purchase_invoice_lines")
@Getter
@Setter
public class PurchaseInvoiceLine extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "purchase_invoice_id", nullable = false)
    private PurchaseInvoice purchaseInvoice;

    @Column(name = "line_number", nullable = false)
    private Integer lineNumber;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "quantity", nullable = false, precision = 20, scale = 4)
    private BigDecimal quantity;

    @Column(name = "unit_price", nullable = false, precision = 20, scale = 4)
    private BigDecimal unitPrice;

    @Column(name = "tax_rate", nullable = false, precision = 5, scale = 4)
    private BigDecimal taxRate = BigDecimal.ZERO;

    @Column(name = "line_subtotal", nullable = false, precision = 20, scale = 4)
    private BigDecimal lineSubtotal;

    @Column(name = "line_tax", nullable = false, precision = 20, scale = 4)
    private BigDecimal lineTax;

    @Column(name = "line_total", nullable = false, precision = 20, scale = 4)
    private BigDecimal lineTotal;
}
