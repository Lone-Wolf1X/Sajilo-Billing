package com.saisa.app.reports.ird;

import com.saisa.billing.domain.invoice.Customer;
import com.saisa.billing.domain.invoice.PurchaseInvoice;
import com.saisa.billing.domain.invoice.SalesInvoice;
import com.saisa.billing.domain.invoice.Vendor;
import com.saisa.billing.infrastructure.persistence.CustomerRepository;
import com.saisa.billing.infrastructure.persistence.PurchaseInvoiceRepository;
import com.saisa.billing.infrastructure.persistence.SalesInvoiceRepository;
import com.saisa.billing.infrastructure.persistence.VendorRepository;
import com.saisa.common.tenant.TenantContext;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;

@Service
public class IrdTaxReportService {

    private final SalesInvoiceRepository salesInvoiceRepo;
    private final PurchaseInvoiceRepository purchaseInvoiceRepo;
    private final CustomerRepository customerRepo;
    private final VendorRepository vendorRepo;

    public IrdTaxReportService(SalesInvoiceRepository salesInvoiceRepo,
                               PurchaseInvoiceRepository purchaseInvoiceRepo,
                               CustomerRepository customerRepo,
                               VendorRepository vendorRepo) {
        this.salesInvoiceRepo = salesInvoiceRepo;
        this.purchaseInvoiceRepo = purchaseInvoiceRepo;
        this.customerRepo = customerRepo;
        this.vendorRepo = vendorRepo;
    }

    public List<D01SalesEntryDto> getD01SalesBook(LocalDate fromDate, LocalDate toDate) {
        Long tenantId = TenantContext.getCurrentTenantId();
        List<SalesInvoice> invoices = (fromDate != null && toDate != null)
                ? salesInvoiceRepo.findByTenantIdAndInvoiceDateBetweenOrderByInvoiceDateAsc(tenantId, fromDate, toDate)
                : salesInvoiceRepo.findByTenantIdOrderByInvoiceDateDesc(tenantId);

        Map<Long, Customer> customerMap = customerRepo.findByTenantIdOrderByCustomerName(tenantId).stream()
                .collect(Collectors.toMap(Customer::getId, c -> c, (a, b) -> a));

        List<D01SalesEntryDto> entries = new ArrayList<>();
        for (SalesInvoice inv : invoices) {
            Customer cust = customerMap.get(inv.getCustomerId());
            String custName = (cust != null) ? cust.getCustomerName() : "Customer #" + inv.getCustomerId();
            String custPan = (cust != null && cust.getPan() != null && !cust.getPan().isBlank())
                    ? cust.getPan()
                    : ((cust != null && cust.getGstin() != null) ? cust.getGstin() : "—");

            BigDecimal tax = inv.getTaxAmount() != null ? inv.getTaxAmount() : BigDecimal.ZERO;
            BigDecimal subtotal = inv.getSubtotal() != null ? inv.getSubtotal() : BigDecimal.ZERO;
            BigDecimal total = inv.getTotalAmount() != null ? inv.getTotalAmount() : BigDecimal.ZERO;

            BigDecimal taxable;
            BigDecimal nonTaxable;

            if (tax.compareTo(BigDecimal.ZERO) > 0) {
                taxable = subtotal;
                nonTaxable = BigDecimal.ZERO;
            } else {
                taxable = BigDecimal.ZERO;
                nonTaxable = total;
            }

            entries.add(new D01SalesEntryDto(
                    inv.getId(),
                    inv.getInvoiceDate(),
                    toBsDate(inv.getInvoiceDate()),
                    inv.getInvoiceNumber(),
                    custName,
                    custPan,
                    total,
                    nonTaxable,
                    taxable,
                    tax,
                    BigDecimal.ZERO
            ));
        }

        return entries;
    }

    public List<D02PurchaseEntryDto> getD02PurchaseBook(LocalDate fromDate, LocalDate toDate) {
        Long tenantId = TenantContext.getCurrentTenantId();
        List<PurchaseInvoice> invoices = (fromDate != null && toDate != null)
                ? purchaseInvoiceRepo.findByTenantIdAndInvoiceDateBetweenOrderByInvoiceDateAsc(tenantId, fromDate, toDate)
                : purchaseInvoiceRepo.findByTenantIdOrderByInvoiceDateDesc(tenantId);

        Map<Long, Vendor> vendorMap = vendorRepo.findByTenantIdOrderByVendorName(tenantId).stream()
                .collect(Collectors.toMap(Vendor::getId, v -> v, (a, b) -> a));

        List<D02PurchaseEntryDto> entries = new ArrayList<>();
        for (PurchaseInvoice inv : invoices) {
            Vendor ven = vendorMap.get(inv.getVendorId());
            String venName = (ven != null) ? ven.getVendorName() : "Vendor #" + inv.getVendorId();
            String venPan = (ven != null && ven.getPan() != null && !ven.getPan().isBlank())
                    ? ven.getPan()
                    : ((ven != null && ven.getGstin() != null) ? ven.getGstin() : "—");

            BigDecimal tax = inv.getTaxAmount() != null ? inv.getTaxAmount() : BigDecimal.ZERO;
            BigDecimal subtotal = inv.getSubtotal() != null ? inv.getSubtotal() : BigDecimal.ZERO;
            BigDecimal total = inv.getTotalAmount() != null ? inv.getTotalAmount() : BigDecimal.ZERO;

            BigDecimal taxable;
            BigDecimal nonTaxable;

            if (tax.compareTo(BigDecimal.ZERO) > 0) {
                taxable = subtotal;
                nonTaxable = BigDecimal.ZERO;
            } else {
                taxable = BigDecimal.ZERO;
                nonTaxable = total;
            }

            entries.add(new D02PurchaseEntryDto(
                    inv.getId(),
                    inv.getInvoiceDate(),
                    toBsDate(inv.getInvoiceDate()),
                    inv.getInvoiceNumber(),
                    venName,
                    venPan,
                    total,
                    nonTaxable,
                    taxable,
                    tax,
                    BigDecimal.ZERO
            ));
        }

        return entries;
    }

    public IrdTaxSummaryResponse getSummary(LocalDate fromDate, LocalDate toDate) {
        List<D01SalesEntryDto> sales = getD01SalesBook(fromDate, toDate);
        List<D02PurchaseEntryDto> purchases = getD02PurchaseBook(fromDate, toDate);

        BigDecimal sTotal = sales.stream().map(D01SalesEntryDto::totalAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal sTaxable = sales.stream().map(D01SalesEntryDto::taxableAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal sNonTaxable = sales.stream().map(D01SalesEntryDto::nonTaxableAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal sVat = sales.stream().map(D01SalesEntryDto::vatAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal sExport = sales.stream().map(D01SalesEntryDto::exportAmount).reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal pTotal = purchases.stream().map(D02PurchaseEntryDto::totalAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal pTaxable = purchases.stream().map(D02PurchaseEntryDto::taxableAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal pNonTaxable = purchases.stream().map(D02PurchaseEntryDto::nonTaxableAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal pVat = purchases.stream().map(D02PurchaseEntryDto::vatAmount).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal pImport = purchases.stream().map(D02PurchaseEntryDto::importAmount).reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal netVat = sVat.subtract(pVat);

        return new IrdTaxSummaryResponse(
                sTotal, sTaxable, sNonTaxable, sVat, sExport,
                pTotal, pTaxable, pNonTaxable, pVat, pImport,
                netVat, sales.size(), purchases.size()
        );
    }

    private String toBsDate(LocalDate ad) {
        if (ad == null) return "—";
        int yearBs = (ad.getMonthValue() > 4 || (ad.getMonthValue() == 4 && ad.getDayOfMonth() >= 14))
                ? ad.getYear() + 57 : ad.getYear() + 56;
        return String.format("%04d-%02d-%02d", yearBs, ad.getMonthValue(), ad.getDayOfMonth());
    }
}
