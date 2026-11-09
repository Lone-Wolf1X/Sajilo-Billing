package com.saisa.billing.application.payment;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class AgingService {

    @PersistenceContext
    private EntityManager em;

    public record AgingRow(
        Long partyId, String partyCode, String partyName,
        Long invoiceId, String invoiceNumber, LocalDate invoiceDate,
        LocalDate dueDate, BigDecimal totalAmount, BigDecimal amountPaid,
        BigDecimal outstanding, long daysOverdue, String bucket
    ) {}

    public record AgingReport(
        LocalDate asOfDate, String partyType,
        List<AgingRow> rows,
        BigDecimal bucket0To30, BigDecimal bucket31To60,
        BigDecimal bucket61To90, BigDecimal bucket90Plus,
        BigDecimal totalOutstanding
    ) {}

    /**
     * AR aging: for each sales invoice with outstanding > 0,
     * bucket by days past due.
     */
    public AgingReport arAging(Long tenantId, LocalDate asOfDate) {
        String sql = """
            SELECT
                c.id, c.customer_code, c.customer_name,
                i.id, i.invoice_number, i.invoice_date, i.due_date,
                i.total_amount, i.amount_paid
            FROM sales_invoices i
            JOIN customers c ON c.id = i.customer_id
            WHERE i.tenant_id = :tenantId
              AND i.status = 'POSTED'
              AND i.total_amount > i.amount_paid
            ORDER BY c.customer_name, i.invoice_date
            """;

        @SuppressWarnings("unchecked")
        List<Object[]> raw = em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .getResultList();

        return buildReport(raw, asOfDate, "CUSTOMER");
    }

    public AgingReport apAging(Long tenantId, LocalDate asOfDate) {
        String sql = """
            SELECT
                v.id, v.vendor_code, v.vendor_name,
                i.id, i.invoice_number, i.invoice_date, i.due_date,
                i.total_amount, i.amount_paid
            FROM purchase_invoices i
            JOIN vendors v ON v.id = i.vendor_id
            WHERE i.tenant_id = :tenantId
              AND i.status = 'POSTED'
              AND i.total_amount > i.amount_paid
            ORDER BY v.vendor_name, i.invoice_date
            """;
        @SuppressWarnings("unchecked")
        List<Object[]> raw = em.createNativeQuery(sql)
            .setParameter("tenantId", tenantId)
            .getResultList();
        return buildReport(raw, asOfDate, "VENDOR");
    }

    private AgingReport buildReport(List<Object[]> raw, LocalDate asOfDate, String partyType) {
        List<AgingRow> rows = new ArrayList<>();
        BigDecimal b0 = BigDecimal.ZERO, b1 = BigDecimal.ZERO, b2 = BigDecimal.ZERO, b3 = BigDecimal.ZERO;
        BigDecimal total = BigDecimal.ZERO;

        for (Object[] r : raw) {
            Long partyId = ((Number) r[0]).longValue();
            String partyCode = (String) r[1];
            String partyName = (String) r[2];
            Long invId = ((Number) r[3]).longValue();
            String invNo = (String) r[4];
            LocalDate invDate = (r[5] instanceof java.sql.Date d) ? d.toLocalDate() : (LocalDate) r[5];
            LocalDate dueDate = r[6] == null
                ? invDate
                : ((r[6] instanceof java.sql.Date d) ? d.toLocalDate() : (LocalDate) r[6]);
            BigDecimal tot = (BigDecimal) r[7];
            BigDecimal paid = r[8] != null ? (BigDecimal) r[8] : BigDecimal.ZERO;
            BigDecimal outstanding = tot.subtract(paid);

            long daysOverdue = ChronoUnit.DAYS.between(dueDate, asOfDate);
            if (daysOverdue < 0) daysOverdue = 0;

            String bucket;
            if (daysOverdue == 0) {
                bucket = "CURRENT";
                b0 = b0.add(outstanding);
            } else if (daysOverdue <= 30) {
                bucket = "1-30";
                b0 = b0.add(outstanding);
            } else if (daysOverdue <= 60) {
                bucket = "31-60";
                b1 = b1.add(outstanding);
            } else if (daysOverdue <= 90) {
                bucket = "61-90";
                b2 = b2.add(outstanding);
            } else {
                bucket = "90+";
                b3 = b3.add(outstanding);
            }

            total = total.add(outstanding);
            rows.add(new AgingRow(partyId, partyCode, partyName,
                invId, invNo, invDate, dueDate, tot, paid, outstanding, daysOverdue, bucket));
        }

        return new AgingReport(asOfDate, partyType, rows, b0, b1, b2, b3, total);
    }
}

