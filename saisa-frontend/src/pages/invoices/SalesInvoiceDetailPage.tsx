import React, { useEffect, useMemo, useState } from 'react';
import { useParams, useNavigate, useSearchParams, Link } from 'react-router-dom';
import { ArrowLeft, Printer, FileText, Building2, LayoutTemplate } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Skeleton } from '../../components/ui/skeleton';
import { InvoiceStatusBadge, PaymentStatusBadge } from '../../components/invoices/InvoiceStatusBadge';
import { useSalesInvoice } from '../../hooks/useSalesInvoices';
import { useCustomer } from '../../hooks/useCustomers';
import { useWarehouses } from '../../hooks/useWarehouses';
import { useCompanyProfile } from '../../hooks/useSetup';
import { useAuthStore } from '../../stores/authStore';
import { formatMoney, amountToWords, getPaymentStatus } from '../../lib/invoiceUtils';
import { NepaliRedWhiteBill } from '../../components/invoices/NepaliRedWhiteBill';

export const SalesInvoiceDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const invoiceId = Number(id);

  const { user } = useAuthStore();
  const { data: invoice, isLoading, isError } = useSalesInvoice(invoiceId);
  const { data: customer } = useCustomer(invoice?.customerId);
  const { data: profile } = useCompanyProfile();
  const { warehouses = [] } = useWarehouses();

  const [template, setTemplate] = useState<'VAT_TAX_INVOICE' | 'NEPALI_RED_WHITE_PAD'>('VAT_TAX_INVOICE');

  const warehouse = useMemo(
    () => warehouses.find((w) => w.id === invoice?.warehouseId),
    [warehouses, invoice?.warehouseId]
  );

  // Auto-print if ?print=true is present
  useEffect(() => {
    if (searchParams.get('print') === 'true' && invoice) {
      const timer = setTimeout(() => {
        window.print();
      }, 500);
      return () => clearTimeout(timer);
    }
  }, [searchParams, invoice]);

  if (isLoading) {
    return (
      <div className="space-y-4 max-w-4xl mx-auto p-4">
        <Skeleton className="h-10 w-48" />
        <Skeleton className="h-96 w-full" />
      </div>
    );
  }

  if (isError || !invoice) {
    return (
      <div className="bg-white border border-paper-border rounded-md p-10 text-center max-w-md mx-auto my-12 shadow-subtle space-y-3">
        <h2 className="font-serif text-lg font-bold text-[#7a2e2e]">
          Invoice Voucher Not Found
        </h2>
        <p className="text-xs text-paper-muted">
          The requested sales invoice #{id} could not be located or may have been deleted.
        </p>
        <Button
          onClick={() => navigate('/invoices')}
          size="sm"
          className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif mt-2"
        >
          Return to Invoices List
        </Button>
      </div>
    );
  }

  const pStatus = getPaymentStatus(invoice);
  const words = amountToWords(invoice.totalAmount);

  return (
    <div className="space-y-6 max-w-4xl mx-auto pb-12">
      {/* Top Action Bar (Hidden on print) */}
      <div className="no-print space-y-3 border-b border-paper-border pb-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <Button
              variant="outline"
              size="sm"
              onClick={() => navigate('/invoices')}
              className="h-8 px-2 text-paper-muted hover:text-paper-text border-paper-border"
            >
              <ArrowLeft className="h-4 w-4 mr-1" />
              <span className="text-xs">All Invoices</span>
            </Button>

            <div className="flex items-center gap-2">
              <h1 className="text-lg font-serif font-bold text-brand-navy font-mono">
                {invoice.invoiceNumber}
              </h1>
              <InvoiceStatusBadge status={invoice.status} />
              <PaymentStatusBadge status={pStatus} />
            </div>
          </div>

          <div className="flex items-center gap-2">
            {invoice.journalEntryId && (
              <Link
                to={`/journal-entries/${invoice.journalEntryId}`}
                className="inline-flex items-center gap-1 text-xs px-2.5 py-1.5 rounded border border-paper-border bg-white text-brand-navy hover:bg-paper-alt transition-colors font-serif"
              >
                <FileText className="h-3.5 w-3.5" />
                <span>Voucher #{invoice.journalEntryId}</span>
              </Link>
            )}

            <Button
              onClick={() => window.print()}
              className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4 shadow-sm flex items-center gap-1.5"
            >
              <Printer className="h-4 w-4" />
              <span>Print Invoice</span>
            </Button>
          </div>
        </div>

        {/* Template Format Selector Tabs */}
        <div className="flex items-center gap-2 pt-1">
          <span className="text-xs font-semibold text-neutral-600 flex items-center gap-1">
            <LayoutTemplate className="w-3.5 h-3.5" />
            <span>बिल ढाँचा (Format):</span>
          </span>

          <button
            type="button"
            onClick={() => setTemplate('VAT_TAX_INVOICE')}
            className={`px-3 py-1 rounded text-xs font-semibold transition-colors ${
              template === 'VAT_TAX_INVOICE'
                ? 'bg-brand-navy text-white shadow-xs'
                : 'bg-white border border-neutral-300 text-neutral-700 hover:bg-neutral-50'
            }`}
          >
            आधिकारिक भ्याट कर बीजक (VAT Tax Invoice - A4)
          </button>

          <button
            type="button"
            onClick={() => setTemplate('NEPALI_RED_WHITE_PAD')}
            className={`px-3 py-1 rounded text-xs font-semibold transition-colors ${
              template === 'NEPALI_RED_WHITE_PAD'
                ? 'bg-red-700 text-white shadow-xs'
                : 'bg-white border border-neutral-300 text-neutral-700 hover:bg-neutral-50'
            }`}
          >
            नेपाली बिल प्याड (Classic Red/White Pad • ९-अंक PAN)
          </button>
        </div>
      </div>

      {/* RENDER TEMPLATE 1: Authentic Nepali Red/White Bill Pad */}
      {template === 'NEPALI_RED_WHITE_PAD' ? (
        <NepaliRedWhiteBill
          invoice={invoice}
          customer={customer}
          warehouse={warehouse}
          profile={profile}
        />
      ) : (
        /* RENDER TEMPLATE 2: Classical Printable Tax Invoice (Paper / Voucher) */
        <div className="bg-white border-2 border-paper-border-strong rounded-md p-6 sm:p-8 shadow-card print:border-none print:shadow-none print:p-0 space-y-6">
          {/* Tax Invoice Header */}
          <div className="text-center border-b-2 border-paper-border-strong pb-4 space-y-1">
            <div className="flex items-center justify-center gap-2">
              <Building2 className="h-5 w-5 text-brand-navy no-print" />
              <h2 className="font-serif text-xl sm:text-2xl font-bold text-brand-navy tracking-wide uppercase">
                {profile?.companyName || user?.tenantCode || 'SAJILO TRADING & ENTERPRISE'}
              </h2>
            </div>
            {profile?.companyNameNepali && (
              <p className="text-sm font-serif font-bold text-neutral-800">
                {profile.companyNameNepali}
              </p>
            )}
            <p className="text-xs text-paper-muted">
              Registered Address: {profile?.toleStreet ? `${profile.toleStreet}, ` : ''}
              {profile?.district || 'Kathmandu'}, {profile?.province || 'Bagmati Province, Nepal'}
            </p>
            <div className="text-xs font-mono font-semibold text-paper-text flex justify-center gap-4 pt-0.5">
              <span>PAN / VAT No: {profile?.panVatNo || profile?.pan || '609823412'}</span>
              <span>Tel: {profile?.phone || profile?.authorizedPersonPhone || '+977-1-4458921'}</span>
            </div>
            <div className="pt-2">
              <span className="inline-block border-y border-paper-border-strong py-0.5 px-6 font-serif font-bold text-sm tracking-widest uppercase text-brand-navy bg-paper-alt">
                TAX INVOICE / कर बीजक
              </span>
            </div>
          </div>

          {/* Invoice Particulars Grid */}
          <div className="grid grid-cols-2 gap-4 text-xs border-b border-paper-border pb-4">
            {/* Customer / Buyer Information */}
            <div className="space-y-1">
              <span className="font-serif font-bold text-paper-muted uppercase text-[10px] block">
                Billed To (Buyer):
              </span>
              <div className="font-serif font-bold text-sm text-paper-text">
                {customer?.customerName || `Customer #${invoice.customerId}`}
              </div>
              {customer?.billingAddress && (
                <div className="text-paper-muted">{customer.billingAddress}</div>
              )}
              <div className="font-mono text-[11px] pt-0.5 text-paper-text">
                <span>Buyer's PAN/VAT: </span>
                <strong className="font-bold">{customer?.pan || customer?.gstin || '—'}</strong>
              </div>
              {customer?.phone && (
                <div className="text-paper-muted">Phone: {customer.phone}</div>
              )}
            </div>

            {/* Invoice Details */}
            <div className="space-y-1.5 text-right font-mono text-xs">
              <div className="flex justify-between sm:justify-end gap-3">
                <span className="font-serif text-paper-muted">Invoice No:</span>
                <strong className="font-bold text-brand-navy">{invoice.invoiceNumber}</strong>
              </div>
              <div className="flex justify-between sm:justify-end gap-3">
                <span className="font-serif text-paper-muted">Invoice Date:</span>
                <span>{invoice.invoiceDate}</span>
              </div>
              <div className="flex justify-between sm:justify-end gap-3">
                <span className="font-serif text-paper-muted">Due Date:</span>
                <span>{invoice.dueDate || 'On Receipt'}</span>
              </div>
              <div className="flex justify-between sm:justify-end gap-3">
                <span className="font-serif text-paper-muted">Warehouse:</span>
                <span>{warehouse?.name || 'Central Store'}</span>
              </div>
            </div>
          </div>

          {/* Line Items Table */}
          <div className="border border-paper-border-strong rounded overflow-hidden">
            <table className="w-full text-xs border-collapse">
              <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted">
                <tr>
                  <th className="w-10 px-2 py-2 font-serif uppercase tracking-wider text-center border-r border-paper-border">
                    S.N.
                  </th>
                  <th className="px-3 py-2 font-serif uppercase tracking-wider text-left border-r border-paper-border">
                    Particulars / Description
                  </th>
                  <th className="w-16 px-2 py-2 font-serif uppercase tracking-wider text-right border-r border-paper-border">
                    Qty
                  </th>
                  <th className="w-24 px-2 py-2 font-serif uppercase tracking-wider text-right border-r border-paper-border">
                    Rate (NPR)
                  </th>
                  <th className="w-24 px-2 py-2 font-serif uppercase tracking-wider text-right border-r border-paper-border">
                    Subtotal
                  </th>
                  <th className="w-16 px-2 py-2 font-serif uppercase tracking-wider text-center border-r border-paper-border">
                    VAT %
                  </th>
                  <th className="w-24 px-2 py-2 font-serif uppercase tracking-wider text-right">
                    Total (NPR)
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-paper-border">
                {invoice.lines.map((line, idx) => {
                  const sub = Number(line.lineSubtotal) || (Number(line.quantity) * Number(line.unitPrice));
                  const tot = Number(line.lineTotal) || (sub + (sub * (Number(line.taxRate) / 100)));

                  return (
                    <tr key={idx} className="hover:bg-paper-warm/20">
                      <td className="px-2 py-2 text-center font-mono text-paper-muted border-r border-paper-border">
                        {idx + 1}
                      </td>
                      <td className="px-3 py-2 font-serif text-paper-text border-r border-paper-border">
                        <div className="font-medium">{line.description || 'General Goods / Services'}</div>
                        {line.itemId && (
                          <span className="font-mono text-[10px] text-paper-muted">
                            Item ID: {line.itemId}
                          </span>
                        )}
                      </td>
                      <td className="px-2 py-2 text-right font-mono text-paper-text border-r border-paper-border">
                        {line.quantity}
                      </td>
                      <td className="px-2 py-2 text-right font-mono text-paper-text border-r border-paper-border">
                        {formatMoney(line.unitPrice, '')}
                      </td>
                      <td className="px-2 py-2 text-right font-mono text-paper-text border-r border-paper-border">
                        {formatMoney(sub, '')}
                      </td>
                      <td className="px-2 py-2 text-center font-mono text-paper-muted border-r border-paper-border">
                        {line.taxRate}%
                      </td>
                      <td className="px-2 py-2 text-right font-mono font-medium text-paper-text">
                        {formatMoney(tot, '')}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          {/* Calculation Summary Box & Amount in Words */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 pt-2">
            {/* Amount In Words */}
            <div className="space-y-3">
              <div className="bg-paper-alt/50 border border-paper-border rounded p-3 text-xs space-y-1">
                <span className="font-serif font-bold text-paper-muted uppercase text-[10px] block">
                  Amount In Words:
                </span>
                <p className="font-serif italic text-paper-text font-medium leading-relaxed">
                  {words}
                </p>
              </div>

              {/* Payment / Settlement Status */}
              <div className="text-xs space-y-1 border border-paper-border rounded p-3 bg-white">
                <div className="flex justify-between font-mono">
                  <span className="font-serif text-paper-muted">Amount Paid:</span>
                  <span className="text-[#2d6a4f] font-semibold">
                    {formatMoney(invoice.amountPaid)}
                  </span>
                </div>
                <div className="flex justify-between font-mono">
                  <span className="font-serif text-paper-muted">Balance Due:</span>
                  <span className={Number(invoice.amountOutstanding) > 0 ? 'text-[#7a2e2e] font-bold' : 'text-paper-muted'}>
                    {formatMoney(invoice.amountOutstanding)}
                  </span>
                </div>
              </div>
            </div>

            {/* Financial Totals */}
            <div className="space-y-1.5 text-xs font-mono">
              <div className="flex justify-between py-1 border-b border-paper-border text-paper-muted">
                <span className="font-serif">Subtotal (Excl. Tax):</span>
                <span>{formatMoney(invoice.subtotal)}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-paper-border text-paper-muted">
                <span className="font-serif">VAT (13%):</span>
                <span>{formatMoney(invoice.taxAmount)}</span>
              </div>
              <div className="flex justify-between py-2 text-brand-navy font-bold text-sm">
                <span className="font-serif">Grand Total (Incl. Tax):</span>
                <span className="underline decoration-double decoration-brand-navy underline-offset-4">
                  {formatMoney(invoice.totalAmount)}
                </span>
              </div>
            </div>
          </div>

          {/* Legal Declaration */}
          <div className="text-[10px] text-paper-muted italic border-t border-paper-border pt-3">
            Declaration: Certified that all the particulars shown in this tax invoice are true, correct and valid. Goods once sold will not be accepted back without prior authorization.
          </div>

          {/* Classical Signatures Block */}
          <div className="grid grid-cols-3 gap-6 pt-12 text-center text-xs font-serif border-t-2 border-paper-border-strong">
            <div>
              <div className="border-t border-dashed border-paper-border pt-1 font-medium">
                Prepared By ({user?.fullName || 'Accountant'})
              </div>
            </div>
            <div>
              <div className="border-t border-dashed border-paper-border pt-1 font-medium">
                Authorized Signature
              </div>
            </div>
            <div>
              <div className="border-t border-dashed border-paper-border pt-1 font-medium">
                Receiver's Signature & Seal
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
