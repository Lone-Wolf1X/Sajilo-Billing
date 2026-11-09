package com.saisa.billing.domain.creditnote;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.*;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "debit_note_lines")
@Getter
@Setter
public class DebitNoteLine extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "debit_note_id", nullable = false)
    private DebitNote debitNote;

    @Column(name = "line_number", nullable = false)
    private Integer lineNumber;

    @Column(name = "item_id")
    private Long itemId;

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

