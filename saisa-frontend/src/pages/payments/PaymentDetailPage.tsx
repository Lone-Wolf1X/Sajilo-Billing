import React, { useMemo } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { ArrowLeft, Printer, ExternalLink, Building2, Ban } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Skeleton } from '../../components/ui/skeleton';
import { PaymentStatusBadge } from '../../components/payments/PaymentStatusBadge';
import { PaymentTypeBadge } from '../../components/payments/PaymentTypeBadge';
import { PaymentAllocationDisplay } from '../../components/payments/PaymentAllocationDisplay';
import { usePayment } from '../../hooks/usePayments';
import { useCustomer } from '../../hooks/useCustomers';
import { useVendor } from '../../hooks/useVendors';
import { useSalesInvoices } from '../../hooks/useSalesInvoices';
import { usePurchaseInvoices } from '../../hooks/usePurchaseInvoices';
import { useBankAccounts } from '../../hooks/useBankAccounts';
import { useAuthStore } from '../../stores/authStore';
import { formatMoney, amountToWords } from '../../lib/invoiceUtils';

export const PaymentDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const paymentId = Number(id);

  const { user } = useAuthStore();
  const { data: payment, isLoading, isError } = usePayment(paymentId);
  const isReceipt = payment?.partyType === 'CUSTOMER';

  const { data: customer } = useCustomer(isReceipt ? payment?.partyId : undefined);
  const { data: vendor } = useVendor(!isReceipt ? payment?.partyId : undefined);
  const { bankAccounts = [] } = useBankAccounts();

  // Query relevant invoices for allocation details
  const salesQuery = useSalesInvoices(isReceipt && payment ? { customerId: payment.partyId, limit: 100 } : undefined);
  const purchaseQuery = usePurchaseInvoices(!isReceipt && payment ? { vendorId: payment.partyId, limit: 100 } : undefined);

  const invoices = isReceipt ? salesQuery.invoices : purchaseQuery.invoices;

  const bank = useMemo(
    () => bankAccounts.find((b) => b.id === payment?.bankAccountId),
    [bankAccounts, payment?.bankAccountId]
  );

  if (isLoading) {
    return (
      <div className="space-y-4 max-w-4xl mx-auto p-4">
        <Skeleton className="h-10 w-48" />
        <Skeleton className="h-96 w-full" />
      </div>
    );
  }

  if (isError || !payment) {
    return (
      <div className="bg-white border border-paper-border rounded-md p-10 text-center max-w-md mx-auto my-12 shadow-subtle space-y-3">
        <h2 className="font-serif text-lg font-bold text-[#7a2e2e]">
          Payment Voucher Not Found
        </h2>
        <p className="text-xs text-paper-muted">
          The requested payment transaction #{id} could not be located.
        </p>
        <Button
          onClick={() => navigate('/payments')}
          size="sm"
          className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif mt-2"
        >
          Return to Payments List
        </Button>
      </div>
    );
  }

  const partyName = isReceipt ? customer?.customerName : vendor?.vendorName;
  const partyPan = isReceipt ? customer?.pan || customer?.gstin : vendor?.pan || vendor?.gstin;
  const partyPhone = isReceipt ? customer?.phone : vendor?.phone;
  const partyAddress = isReceipt ? customer?.billingAddress : vendor?.billingAddress;
  const words = amountToWords(payment.amount);

  return (
    <div className="space-y-6 max-w-4xl mx-auto pb-12">
      {/* Top Action Bar (Hidden on print) */}
      <div className="no-print flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-paper-border pb-4">
        <div className="flex items-center gap-3">
          <Button
            variant="outline"
            size="sm"
            onClick={() => navigate('/payments')}
            className="h-8 px-2 text-paper-muted hover:text-paper-text border-paper-border"
          >
            <ArrowLeft className="h-4 w-4 mr-1" />
            <span className="text-xs">All Payments</span>
          </Button>

          <div className="flex items-center gap-2">
            <h1 className="text-lg font-serif font-bold text-brand-navy font-mono">
              {payment.paymentNumber}
            </h1>
            <PaymentTypeBadge partyType={payment.partyType} />
            <PaymentStatusBadge status={payment.status} />
          </div>
        </div>

        <div className="flex items-center gap-2">
          {payment.journalEntryId && (
            <Link
              to={`/journal-entries/${payment.journalEntryId}`}
              className="inline-flex items-center gap-1 text-xs px-2.5 py-1.5 rounded border border-paper-border bg-white text-brand-navy hover:bg-paper-alt transition-colors font-serif"
            >
              <ExternalLink className="h-3.5 w-3.5" />
              <span>Voucher #{payment.journalEntryId}</span>
            </Link>
          )}

          <Button
            variant="outline"
            size="sm"
            disabled
            title="Payment reversals will be available in Step 19"
            className="text-xs border-paper-border text-paper-muted opacity-60 cursor-not-allowed"
          >
            <Ban className="h-3.5 w-3.5 mr-1" />
            Void Voucher
          </Button>

          <Button
            onClick={() => window.print()}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4 shadow-sm flex items-center gap-1.5"
          >
            <Printer className="h-4 w-4" />
            <span>Print {isReceipt ? 'Receipt' : 'Voucher'}</span>
          </Button>
        </div>
      </div>

      {/* Classical Printable Money Receipt / Payment Voucher */}
      <div className="payment-print-container bg-white border-2 border-paper-border-strong rounded-md p-6 sm:p-8 shadow-card print:border-none print:shadow-none print:p-0 space-y-6">
        {/* Document Header */}
        <div className="text-center border-b-2 border-paper-border-strong pb-4 space-y-1">
          <div className="flex items-center justify-center gap-2">
            <Building2 className="h-5 w-5 text-brand-navy no-print" />
            <h2 className="font-serif text-xl sm:text-2xl font-bold text-brand-navy tracking-wide uppercase">
              {user?.tenantCode || 'SAJILO TRADING & ENTERPRISE'}
            </h2>
          </div>
          <p className="text-xs text-paper-muted">
            Registered Address: Kathmandu, Bagmati Province, Nepal
          </p>
          <div className="text-xs font-mono font-semibold text-paper-text flex justify-center gap-4 pt-0.5">
            <span>PAN / VAT No: 609823412</span>
            <span>Tel: +977-1-4458921</span>
          </div>
          <div className="pt-2">
            <span className="inline-block border-y border-paper-border-strong py-0.5 px-6 font-serif font-bold text-sm tracking-widest uppercase text-brand-navy bg-paper-alt">
              {isReceipt ? 'MONEY RECEIPT / रसिद' : 'PAYMENT VOUCHER / भुक्तानी भौचर'}
            </span>
          </div>
        </div>

        {/* Voucher Particulars Grid */}
        <div className="grid grid-cols-2 gap-4 text-xs border-b border-paper-border pb-4">
          {/* Party details */}
          <div className="space-y-1">
            <span className="font-serif font-bold text-paper-muted uppercase text-[10px] block">
              {isReceipt ? 'Received From (Customer):' : 'Paid To (Supplier / Payee):'}
            </span>
            <div className="font-serif font-bold text-sm text-paper-text">
              {partyName || `${isReceipt ? 'Customer' : 'Vendor'} #${payment.partyId}`}
            </div>
            {partyAddress && (
              <div className="text-paper-muted">{partyAddress}</div>
            )}
            <div className="font-mono text-[11px] pt-0.5 text-paper-text">
              <span>PAN / VAT: </span>
              <strong className="font-bold">{partyPan || '—'}</strong>
            </div>
            {partyPhone && (
              <div className="text-paper-muted">Phone: {partyPhone}</div>
            )}
          </div>

          {/* Payment metadata */}
          <div className="space-y-1.5 text-right font-mono text-xs">
            <div className="flex justify-between sm:justify-end gap-3">
              <span className="font-serif text-paper-muted">Voucher No:</span>
              <strong className="font-bold text-brand-navy">{payment.paymentNumber}</strong>
            </div>
            <div className="flex justify-between sm:justify-end gap-3">
              <span className="font-serif text-paper-muted">Payment Date:</span>
              <span>{payment.paymentDate}</span>
            </div>
            <div className="flex justify-between sm:justify-end gap-3">
              <span className="font-serif text-paper-muted">Payment Method:</span>
              <span className="font-bold uppercase text-[11px]">
                {payment.paymentMethod.replace('_', ' ')}
              </span>
            </div>
            {bank && (
              <div className="flex justify-between sm:justify-end gap-3">
                <span className="font-serif text-paper-muted">Bank Account:</span>
                <span>{bank.bankName || bank.accountName}</span>
              </div>
            )}
            {payment.referenceNo && (
              <div className="flex justify-between sm:justify-end gap-3">
                <span className="font-serif text-paper-muted">Reference / Instrument:</span>
                <span className="font-bold">{payment.referenceNo}</span>
              </div>
            )}
          </div>
        </div>

        {/* Highlighted Amount Box */}
        <div
          className={`p-4 rounded border text-center space-y-1 ${
            isReceipt
              ? 'bg-[#eaf4ef] border-[#b7ddcb]'
              : 'bg-[#fdf2f2] border-[#f3bebe]'
          }`}
        >
          <span className="font-serif font-bold text-paper-muted uppercase text-[10px] tracking-wider block">
            {isReceipt ? 'Total Amount Received' : 'Total Amount Paid'}
          </span>
          <div
            className={`font-mono text-3xl font-bold ${
              isReceipt ? 'text-[#2d6a4f]' : 'text-[#7a2e2e]'
            }`}
          >
            {formatMoney(payment.amount)}
          </div>
          <div className="font-serif italic text-xs text-paper-text pt-0.5">
            {words}
          </div>
        </div>

        {/* Invoice Allocations Table */}
        <div className="space-y-2">
          <h3 className="font-serif font-bold text-xs text-brand-navy uppercase tracking-wider">
            {isReceipt
              ? 'Settlement Allocation against Sales Invoices'
              : 'Settlement Allocation against Purchase Bills'}
          </h3>

          <PaymentAllocationDisplay
            allocations={payment.allocations}
            invoices={invoices}
            invoiceType={isReceipt ? 'SALES' : 'PURCHASE'}
          />

          {Number(payment.unallocatedAmount) > 0.001 && (
            <div className="p-2.5 bg-[#fef3c7] border border-[#fde68a] rounded text-xs text-[#92400e] flex items-center justify-between font-mono">
              <span>
                <strong>Advance Balance on Account:</strong> The unallocated amount will be preserved as advance credit.
              </span>
              <strong className="font-bold text-sm">
                {formatMoney(payment.unallocatedAmount)}
              </strong>
            </div>
          )}
        </div>

        {/* Classical Signatures Block */}
        <div className="grid grid-cols-3 gap-6 pt-12 text-center text-xs font-serif border-t-2 border-paper-border-strong">
          <div>
            <div className="border-t border-dashed border-paper-border pt-1 font-medium">
              Prepared By ({user?.fullName || 'Cashier'})
            </div>
          </div>
          <div>
            <div className="border-t border-dashed border-paper-border pt-1 font-medium">
              Authorized Signatory
            </div>
          </div>
          <div>
            <div className="border-t border-dashed border-paper-border pt-1 font-medium">
              {isReceipt ? "Customer's Acknowledgment" : "Payee's Signature & Stamp"}
            </div>
          </div>
        </div>

        {/* Audit footer */}
        <div className="text-[10px] text-paper-muted italic border-t border-paper-border pt-2 flex justify-between">
          <span>System Generated Voucher · Status: {payment.status}</span>
          <span>Printed on {new Date().toLocaleDateString('en-IN')}</span>
        </div>
      </div>
    </div>
  );
};

