package com.saisa.app.metrics;

import com.saisa.billing.domain.event.CreditNotePostedEvent;
import com.saisa.billing.domain.event.PaymentPostedEvent;
import com.saisa.billing.domain.event.SalesInvoicePostedEvent;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class BusinessMetrics {

    private final Counter journalEntriesPosted;
    private final Counter salesInvoicesCreated;
    private final Counter paymentsPosted;
    private final Counter creditNotesPosted;

    public BusinessMetrics(MeterRegistry registry) {
        this.journalEntriesPosted = Counter.builder("saisa.journal_entries.posted.total")
            .description("Total journal entries posted")
            .register(registry);
        this.salesInvoicesCreated = Counter.builder("saisa.sales_invoices.created.total")
            .description("Total sales invoices created")
            .register(registry);
        this.paymentsPosted = Counter.builder("saisa.payments.posted.total")
            .description("Total payments posted")
            .register(registry);
        this.creditNotesPosted = Counter.builder("saisa.credit_notes.posted.total")
            .description("Total credit notes posted")
            .register(registry);
    }

    public void journalEntryPosted() { journalEntriesPosted.increment(); }
    public void salesInvoiceCreated() { salesInvoicesCreated.increment(); }
    public void paymentPosted() { paymentsPosted.increment(); }
    public void creditNotePosted() { creditNotesPosted.increment(); }

    @EventListener
    public void onSalesInvoicePosted(SalesInvoicePostedEvent event) {
        salesInvoiceCreated();
    }

    @EventListener
    public void onPaymentPosted(PaymentPostedEvent event) {
        paymentPosted();
    }

    @EventListener
    public void onCreditNotePosted(CreditNotePostedEvent event) {
        creditNotePosted();
    }
}
