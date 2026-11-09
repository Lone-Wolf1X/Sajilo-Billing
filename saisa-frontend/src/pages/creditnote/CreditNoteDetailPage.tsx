import React from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft, Printer, ExternalLink, AlertCircle } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Skeleton } from '../../components/ui/skeleton';
import { useCreditNote } from '../../hooks/useCreditNotes';
import { useCustomer } from '../../hooks/useCustomers';
import { useSalesInvoice } from '../../hooks/useSalesInvoices';
import { useAuth } from '../../hooks/useAuth';
import { formatMoney, amountToWords } from '../../lib/invoiceUtils';

const fmtDate = (d?: string | null) => {
  if (!d) return '—';
  try {
    return new Date(d).toLocaleDateString('en-IN', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
    });
  } catch {
    return d;
  }
};

const fmtDateTime = (d?: string | null) => {
  if (!d) return '—';
  try {
    return new Date(d).toLocaleString('en-IN', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  } catch {
    return d;
  }
};

export const CreditNoteDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const creditNoteId = Number(id);
  const { user } = useAuth();

  const { data: note, isLoading, error } = useCreditNote(creditNoteId);
  const { data: customer } = useCustomer(note?.customerId ?? 0);
  const { data: originalInvoice } = useSalesInvoice(note?.originalInvoiceId ?? 0);

  if (isLoading) {
    return (
      <div className="p-6 max-w-5xl mx-auto space-y-4">
        <Skeleton className="h-8 w-48" />
        <Skeleton className="h-64 w-full" />
      </div>
    );
  }

  if (error || !note) {
    return (
      <div className="p-6 max-w-5xl mx-auto">
        <div className="bg-rose-50 border border-rose-200 text-rose-800 rounded-lg p-6 text-center space-y-3">
          <AlertCircle size={36} className="mx-auto text-rose-600" />
          <h2 className="font-serif text-lg font-bold">Credit Note Not Found</h2>
          <p className="text-xs text-rose-700">
            The requested credit note could not be retrieved. It may not exist or belongs to another organization.
          </p>
          <Link to="/credit-notes">
            <Button variant="outline" size="sm" className="mt-2 border-rose-300 text-rose-800 hover:bg-rose-100 font-serif text-xs">
              <ArrowLeft size={14} className="mr-1" /> Back to Credit Notes
            </Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="p-6 max-w-5xl mx-auto space-y-6">
      {/* Action Bar (hidden in print) */}
      <div className="no-print flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <Link
            to="/credit-notes"
            className="text-xs font-serif text-paper-muted hover:text-brand-navy flex items-center gap-1 mb-1 transition-colors"
          >
            <ArrowLeft size={12} /> Back to Credit Notes
          </Link>
          <div className="flex items-center gap-3">
            <h1 className="font-serif text-2xl font-bold text-brand-navy">
              {note.creditNoteNumber}
            </h1>
            <span
              className={`inline-block text-[10px] font-serif uppercase tracking-wider font-semibold px-2 py-0.5 rounded border ${
                note.status === 'POSTED'
                  ? 'bg-emerald-50 text-emerald-800 border-emerald-200'
                  : note.status === 'DRAFT'
                  ? 'bg-amber-50 text-amber-800 border-amber-200'
                  : 'bg-gray-100 text-gray-700 border-gray-300'
              }`}
            >
              {note.status}
            </span>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={() => window.print()}
            className="border-paper-border text-brand-navy hover:bg-paper-alt font-serif text-xs px-3.5 flex items-center gap-1.5"
          >
            <Printer size={15} />
            <span>Print Voucher</span>
          </Button>

          {note.journalEntryId && (
            <Link to={`/journal-entries/${note.journalEntryId}`}>
              <Button
                type="button"
                variant="outline"
                className="border-brand-navy/30 text-brand-navy hover:bg-brand-navy/5 font-serif text-xs px-3.5 flex items-center gap-1.5"
              >
                <ExternalLink size={15} />
                <span>View Journal Entry</span>
              </Button>
            </Link>
          )}
        </div>
      </div>

      {/* Printable Voucher Document */}
      <div className="credit-note-print-container bg-white border border-paper-border rounded-lg p-6 sm:p-8 shadow-sm">
        {/* Document Header */}
        <div className="text-center border-b-2 border-double border-paper-border-strong pb-4 mb-6">
          <h2 className="font-serif text-2xl font-bold text-brand-navy tracking-wide uppercase">
            {user?.tenantCode ? `${user.tenantCode} ENTERPRISES` : 'SAISA COMMERCE'}
          </h2>
          <div className="text-xs font-serif text-paper-muted uppercase tracking-widest mt-0.5">
            Registered Accounting Entity · VAT Compliance System
          </div>
          <h3 className="font-serif text-lg font-bold text-brand-burgundy mt-2 uppercase tracking-wider">
            CREDIT NOTE / जम्मा बिजक
          </h3>
        </div>

        {/* Metadata & Party Details */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 text-sm mb-6 pb-6 border-b border-paper-border">
          <div className="space-y-2">
            <div>
              <span className="text-xs font-serif uppercase tracking-wider text-paper-muted block">
                Credit Note Number
              </span>
              <span className="font-mono font-bold text-base text-brand-navy">
                {note.creditNoteNumber}
              </span>
            </div>
            <div>
              <span className="text-xs font-serif uppercase tracking-wider text-paper-muted block">
                Issue Date
              </span>
              <span className="font-mono text-sm text-paper-text">
                {fmtDate(note.creditNoteDate)}
              </span>
            </div>
            {note.reason && (
              <div>
                <span className="text-xs font-serif uppercase tracking-wider text-paper-muted block">
                  Return Reason / Purpose
                </span>
                <span className="text-xs text-brand-navy italic">
                  "{note.reason}"
                </span>
              </div>
            )}
          </div>

          <div className="space-y-2">
            <div>
              <span className="text-xs font-serif uppercase tracking-wider text-paper-muted block">
                Customer (Debtor)
              </span>
              <span className="font-serif font-bold text-base text-brand-navy">
                {customer?.customerName ?? `Customer #${note.customerId}`}
              </span>
              {customer?.customerCode && (
                <div className="text-xs font-mono text-paper-muted">
                  Code: {customer.customerCode}
                </div>
              )}
              {customer?.pan && (
                <div className="text-xs font-mono text-paper-muted">
                  PAN / GSTIN: <strong className="text-brand-navy">{customer.pan}</strong>
                </div>
              )}
              {customer?.billingAddress && (
                <div className="text-xs text-paper-muted mt-0.5">
                  {customer.billingAddress}
                </div>
              )}
            </div>

            {note.originalInvoiceId && (
              <div className="pt-2">
                <span className="text-xs font-serif uppercase tracking-wider text-paper-muted block">
                  Adjusted Against Original Invoice
                </span>
                <div className="font-mono text-xs">
                  <Link
                    to={`/invoices/${note.originalInvoiceId}`}
                    className="text-brand-navy font-semibold hover:underline"
                  >
                    {originalInvoice?.invoiceNumber ?? `Invoice #${note.originalInvoiceId}`}
                  </Link>
                  {originalInvoice && (
                    <span className="text-paper-muted ml-2">
                      (Dated: {fmtDate(originalInvoice.invoiceDate)} · Total: {formatMoney(originalInvoice.totalAmount)})
                    </span>
                  )}
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Amount Highlight Card */}
        <div className="text-center py-4 px-6 rounded-lg mb-6 bg-emerald-50/70 border border-emerald-200">
          <div className="text-xs font-serif uppercase tracking-widest text-emerald-800 font-semibold mb-1">
            Total Sales Credit Recognized
          </div>
          <div className="font-serif text-3xl sm:text-4xl font-bold text-emerald-800">
            {formatMoney(note.totalAmount)}
          </div>
          <div className="text-xs font-serif italic text-emerald-900/80 mt-1">
            ({amountToWords(parseFloat(note.totalAmount || '0'))})
          </div>
        </div>

        {/* Lines Table */}
        <div className="overflow-x-auto border border-paper-border rounded-md shadow-sm mb-6">
          <table className="w-full text-sm border-collapse bg-white">
            <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-brand-navy">
              <tr>
                <th className="w-10 px-3 py-2.5 text-xs font-serif uppercase tracking-wider text-center text-paper-muted">
                  #
                </th>
                <th className="px-4 py-2.5 text-xs font-serif uppercase tracking-wider text-left text-paper-muted">
                  Item / Description
                </th>
                <th className="px-3 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-20">
                  Qty
                </th>
                <th className="px-3 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-28">
                  Rate
                </th>
                <th className="px-3 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-20">
                  Tax %
                </th>
                <th className="px-4 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-28">
                  Subtotal
                </th>
                <th className="px-4 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-24">
                  Tax
                </th>
                <th className="px-4 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-28">
                  Total
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-paper-border">
              {note.lines.map((line, index) => (
                <tr key={line.id ?? index} className="hover:bg-paper-alt/30 transition-colors">
                  <td className="text-center text-xs font-mono text-paper-muted px-3 py-2.5">
                    {line.lineNumber ?? index + 1}
                  </td>
                  <td className="px-4 py-2.5">
                    <div className="text-xs font-serif text-brand-navy">
                      {line.description ?? '—'}
                    </div>
                  </td>
                  <td className="text-right font-mono tabular-nums text-xs px-3 py-2.5">
                    {parseFloat(line.quantity || '0').toLocaleString('en-IN')}
                  </td>
                  <td className="text-right font-mono tabular-nums text-xs px-3 py-2.5">
                    {formatMoney(line.unitPrice)}
                  </td>
                  <td className="text-right font-mono tabular-nums text-xs px-3 py-2.5">
                    {(parseFloat(line.taxRate || '0') * 100).toFixed(0)}%
                  </td>
                  <td className="text-right font-mono tabular-nums text-xs px-4 py-2.5 text-paper-text">
                    {formatMoney(line.lineSubtotal)}
                  </td>
                  <td className="text-right font-mono tabular-nums text-xs px-4 py-2.5 text-paper-muted">
                    {formatMoney(line.lineTax)}
                  </td>
                  <td className="text-right font-mono tabular-nums text-xs font-semibold px-4 py-2.5 text-brand-navy">
                    {formatMoney(line.lineTotal)}
                  </td>
                </tr>
              ))}
            </tbody>
            <tfoot className="bg-paper-alt/60 border-t-4 border-double border-paper-border-strong text-brand-navy font-mono">
              <tr>
                <td colSpan={5} className="px-4 py-2 text-right text-xs font-serif uppercase font-semibold text-paper-muted">
                  Subtotal (Net Return)
                </td>
                <td colSpan={3} className="px-4 py-2 text-right font-mono tabular-nums text-xs font-semibold">
                  {formatMoney(note.subtotal)}
                </td>
              </tr>
              <tr>
                <td colSpan={5} className="px-4 py-2 text-right text-xs font-serif uppercase font-semibold text-paper-muted">
                  VAT Output Reversed
                </td>
                <td colSpan={3} className="px-4 py-2 text-right font-mono tabular-nums text-xs font-semibold">
                  {formatMoney(note.taxAmount)}
                </td>
              </tr>
              <tr className="border-t-2 border-paper-border-strong bg-paper-alt">
                <td colSpan={5} className="px-4 py-3 text-right text-sm font-serif uppercase font-bold text-brand-navy">
                  Total Credit Amount
                </td>
                <td colSpan={3} className="px-4 py-3 text-right font-mono tabular-nums font-bold text-emerald-800 text-base">
                  {formatMoney(note.totalAmount)}
                </td>
              </tr>
            </tfoot>
          </table>
        </div>

        {/* Double-Entry Accounting Reference */}
        <div className="bg-paper-alt/40 border border-paper-border rounded p-3 text-xs text-paper-muted flex items-center justify-between">
          <div>
            <strong className="text-brand-navy font-serif">Accounting Impact:</strong> Sales Returns (Dr) · VAT Output (Dr) · Accounts Receivable (Cr)
          </div>
          {note.journalEntryId && (
            <div className="font-mono text-[11px]">
              Voucher Ref: <strong className="text-brand-navy">JE #{note.journalEntryId}</strong>
            </div>
          )}
        </div>

        {/* 3-Tier Signatures (Print & Audit) */}
        <div className="mt-14 pt-4 grid grid-cols-3 gap-8 text-xs text-center font-serif text-brand-navy">
          <div>
            <div className="border-t border-paper-border-strong pt-2">
              <div className="font-semibold">Prepared By</div>
              <div className="text-[10px] text-paper-muted">{user?.fullName ?? 'Operator'}</div>
            </div>
          </div>
          <div>
            <div className="border-t border-paper-border-strong pt-2">
              <div className="font-semibold">Checked & Verified By</div>
              <div className="text-[10px] text-paper-muted">Accountant / Auditor</div>
            </div>
          </div>
          <div>
            <div className="border-t border-paper-border-strong pt-2">
              <div className="font-semibold">Authorized Signatory</div>
              <div className="text-[10px] text-paper-muted">Chief Financial Officer</div>
            </div>
          </div>
        </div>

        {/* Audit Timestamp Footer */}
        <div className="mt-8 pt-3 border-t border-paper-border text-[11px] text-paper-muted flex flex-col sm:flex-row justify-between items-center gap-1">
          <div>
            Document Status: <strong className="text-brand-navy">{note.status}</strong>
            {note.postedAt && ` · Certified Posted: ${fmtDateTime(note.postedAt)}`}
          </div>
          <div>
            Printed: {fmtDateTime(new Date().toISOString())}
          </div>
        </div>
      </div>
    </div>
  );
};
