import React, { useMemo, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { toast } from 'sonner';
import { ArrowLeft, Save, CheckCircle2, DollarSign } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { CustomerCombobox } from '../../components/invoices/CustomerCombobox';
import { VendorCombobox } from '../../components/invoices/VendorCombobox';
import { PaymentMethodSelector } from '../../components/payments/PaymentMethodSelector';
import {
  InvoiceAllocationTable,
  type Allocation,
  type UnpaidInvoice,
} from '../../components/payments/InvoiceAllocationTable';
import { useCreatePayment } from '../../hooks/usePayments';
import { useSalesInvoices } from '../../hooks/useSalesInvoices';
import { usePurchaseInvoices } from '../../hooks/usePurchaseInvoices';
import { generatePaymentNumber } from '../../lib/paymentUtils';
import { formatMoney } from '../../lib/invoiceUtils';
import type { PaymentMethod, CreatePaymentRequest } from '../../types/payment';

interface Props {
  mode: 'receipt' | 'payment';
}

export const PaymentFormPage: React.FC<Props> = ({ mode }) => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const createMutation = useCreatePayment();

  const isReceipt = mode === 'receipt';
  const initialPartyId = searchParams.get('partyId')
    ? Number(searchParams.get('partyId'))
    : null;

  const [paymentNumber] = useState(() => generatePaymentNumber(mode));
  const [paymentDate, setPaymentDate] = useState(() =>
    new Date().toISOString().slice(0, 10)
  );
  const [amount, setAmount] = useState('');
  const [partyId, setPartyId] = useState<number | null>(initialPartyId);
  const [method, setMethod] = useState<PaymentMethod>('CASH');
  const [bankAccountId, setBankAccountId] = useState<number | null>(null);
  const [referenceNo, setReferenceNo] = useState('');
  const [notes, setNotes] = useState('');
  const [allocations, setAllocations] = useState<Allocation[]>([]);

  // Query unpaid vouchers for this party
  const salesQuery = useSalesInvoices(
    isReceipt && partyId ? { customerId: partyId, limit: 100 } : undefined
  );
  const purchaseQuery = usePurchaseInvoices(
    !isReceipt && partyId ? { vendorId: partyId, limit: 100 } : undefined
  );

  const rawInvoices = isReceipt ? salesQuery.invoices : purchaseQuery.invoices;

  const unpaidInvoices: UnpaidInvoice[] = useMemo(() => {
    if (!partyId || !rawInvoices) return [];
    return rawInvoices
      .filter((inv) => {
        const tot = Number(inv.totalAmount) || 0;
        const paid = Number(inv.amountPaid) || 0;
        const outstanding = Number(inv.amountOutstanding);
        if (!isNaN(outstanding)) {
          return outstanding > 0.001;
        }
        return tot - paid > 0.001;
      })
      .map((inv) => ({
        id: inv.id,
        invoiceNumber: inv.invoiceNumber,
        invoiceDate: inv.invoiceDate,
        dueDate: inv.dueDate,
        totalAmount: inv.totalAmount,
        amountPaid: inv.amountPaid,
        amountOutstanding: inv.amountOutstanding,
      }));
  }, [partyId, rawInvoices]);

  const totalAllocated = useMemo(() => {
    return allocations.reduce(
      (sum, a) => sum + (parseFloat(a.amount) || 0),
      0
    );
  }, [allocations]);

  const parsedAmount = parseFloat(amount) || 0;
  const unallocated = Math.round((parsedAmount - totalAllocated) * 100) / 100;
  const canSubmit =
    partyId !== null &&
    parsedAmount > 0 &&
    unallocated >= -0.001;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!partyId) {
      toast.error(`Please select a ${isReceipt ? 'customer' : 'supplier'}.`);
      return;
    }
    if (parsedAmount <= 0) {
      toast.error('Payment amount must be greater than zero.');
      return;
    }
    if (unallocated < -0.001) {
      toast.error(
        'Allocated amount cannot exceed the total payment amount received.'
      );
      return;
    }

    try {
      const payload: CreatePaymentRequest = {
        paymentNumber,
        paymentDate,
        amount,
        partyType: isReceipt ? 'CUSTOMER' : 'VENDOR',
        partyId,
        paymentMethod: method,
        bankAccountId: bankAccountId ?? undefined,
        referenceNo: referenceNo.trim() || undefined,
        notes: notes.trim() || undefined,
        idempotencyKey: `${paymentNumber}-${Date.now()}`,
        allocations: allocations.map((a) => ({
          invoiceType: isReceipt ? 'SALES' : 'PURCHASE',
          invoiceId: a.invoiceId,
          amount: a.amount,
        })),
      };

      await createMutation.mutateAsync(payload);
      if (isReceipt) {
        navigate('/invoices');
      } else {
        navigate('/purchase-invoices');
      }
    } catch {
      // toast is handled in mutation hook
    }
  };

  return (
    <div className="space-y-5 max-w-5xl mx-auto pb-12">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-paper-border pb-4">
        <div className="flex items-center gap-3">
          <Button
            variant="outline"
            size="sm"
            onClick={() => navigate(isReceipt ? '/invoices' : '/purchase-invoices')}
            className="h-8 px-2 text-paper-muted hover:text-paper-text border-paper-border"
          >
            <ArrowLeft className="h-4 w-4 mr-1" />
            <span className="text-xs">
              {isReceipt ? 'Invoices' : 'Purchase Bills'}
            </span>
          </Button>

          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-xl font-serif font-bold text-brand-navy">
                {isReceipt
                  ? 'Customer Payment Receipt'
                  : 'Vendor Payment Voucher'}
              </h1>
              <span className="key-tag text-[10px] bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border text-paper-muted">
                {isReceipt ? 'F6' : 'F5'}
              </span>
            </div>
            <p className="text-xs text-paper-muted mt-0.5">
              {isReceipt
                ? 'Record cash or bank receipt against customer sales invoices and update Accounts Receivable.'
                : 'Disburse payment to suppliers, clear purchase bills, and update Accounts Payable.'}
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={() => navigate(isReceipt ? '/invoices' : '/purchase-invoices')}
            className="text-xs border-paper-border"
          >
            Cancel
          </Button>

          <Button
            type="button"
            onClick={handleSubmit}
            disabled={!canSubmit || createMutation.isPending}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4 shadow-sm flex items-center gap-1.5"
          >
            {createMutation.isPending ? (
              'Posting Payment...'
            ) : (
              <>
                <CheckCircle2 className="h-4 w-4" />
                <span>
                  Post {isReceipt ? 'Receipt' : 'Payment'}
                </span>
              </>
            )}
          </Button>
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-5">
        {/* Payment Metadata Card */}
        <div className="bg-white border border-paper-border rounded-md p-4 shadow-subtle space-y-4">
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            {/* Payment Number */}
            <div className="space-y-1">
              <Label className="text-xs font-serif font-bold text-paper-text">
                Voucher / Receipt # *
              </Label>
              <Input
                value={paymentNumber}
                readOnly
                className="font-mono text-xs h-9 bg-paper-alt/50 cursor-not-allowed"
              />
            </div>

            {/* Date */}
            <div className="space-y-1">
              <Label className="text-xs font-serif font-bold text-paper-text">
                Payment Date *
              </Label>
              <Input
                type="date"
                value={paymentDate}
                onChange={(e) => setPaymentDate(e.target.value)}
                className="font-mono text-xs h-9 bg-white"
              />
            </div>

            {/* Total Amount */}
            <div className="space-y-1">
              <Label className="text-xs font-serif font-bold text-brand-navy">
                Amount Received (NPR) *
              </Label>
              <Input
                value={amount}
                onChange={(e) => {
                  const cleaned = e.target.value.replace(/,/g, '').trim();
                  if (cleaned === '' || /^\d*(\.\d{0,4})?$/.test(cleaned)) {
                    setAmount(cleaned);
                  }
                }}
                placeholder="0.00"
                className="font-mono text-xs font-bold text-right h-9 bg-white text-brand-navy"
              />
            </div>
          </div>

          {/* Party Selection (Customer / Vendor) */}
          <div className="pt-2 border-t border-paper-border/60">
            <Label className="text-xs font-serif font-bold text-paper-text block mb-1">
              {isReceipt ? 'Customer / Remitter *' : 'Vendor / Beneficiary *'}
            </Label>
            {isReceipt ? (
              <CustomerCombobox
                value={partyId}
                onChange={(id) => {
                  setPartyId(id);
                  setAllocations([]);
                }}
              />
            ) : (
              <VendorCombobox
                value={partyId}
                onChange={(id) => {
                  setPartyId(id);
                  setAllocations([]);
                }}
              />
            )}
          </div>

          {/* Payment Method & Bank */}
          <div className="pt-2 border-t border-paper-border/60">
            <PaymentMethodSelector
              method={method}
              bankAccountId={bankAccountId}
              referenceNo={referenceNo}
              onMethodChange={setMethod}
              onBankAccountChange={setBankAccountId}
              onReferenceChange={setReferenceNo}
            />
          </div>

          {/* Notes */}
          <div className="pt-2 border-t border-paper-border/60">
            <Label className="text-xs font-serif text-paper-text">
              Narration / Notes
            </Label>
            <Input
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="e.g. Cleared via Fonepay / Check clearance acknowledgment"
              className="text-xs h-9 bg-white mt-1"
            />
          </div>
        </div>

        {/* Invoice Allocation Section */}
        {partyId !== null && (
          <div className="bg-white border border-paper-border rounded-md p-4 shadow-subtle space-y-3">
            <div className="flex items-center justify-between border-b border-paper-border pb-2">
              <h2 className="text-xs font-serif font-bold text-brand-navy uppercase tracking-wider flex items-center gap-1.5">
                <DollarSign className="h-3.5 w-3.5" />
                Voucher Settlements & Invoice Allocation
              </h2>
              <span className="text-[11px] text-paper-muted">
                {unpaidInvoices.length} outstanding invoice(s) eligible
              </span>
            </div>

            <InvoiceAllocationTable
              invoices={unpaidInvoices}
              allocations={allocations}
              paymentAmount={amount}
              onAllocationsChange={setAllocations}
            />
          </div>
        )}

        {/* Bottom Submission Bar */}
        <div className="bg-white border border-paper-border rounded-md p-4 flex flex-col sm:flex-row items-center justify-between gap-3 shadow-subtle">
          <div className="text-xs space-x-2">
            {parsedAmount > 0 ? (
              <span>
                Total Amount: <strong>{formatMoney(parsedAmount)}</strong>
                {totalAllocated > 0 && (
                  <span className="text-paper-muted">
                    {' '}
                    · Allocated: {formatMoney(totalAllocated.toFixed(2))}
                  </span>
                )}
                {unallocated > 0.001 && (
                  <span className="text-amber-700 font-semibold">
                    {' '}
                    · Unallocated (Advance): {formatMoney(unallocated.toFixed(2))}
                  </span>
                )}
              </span>
            ) : (
              <span className="text-paper-muted italic">
                Enter payment amount to allocate against vouchers.
              </span>
            )}
          </div>

          <div className="flex items-center gap-2">
            <Button
              type="button"
              variant="outline"
              onClick={() => navigate(isReceipt ? '/invoices' : '/purchase-invoices')}
              className="text-xs border-paper-border"
            >
              Cancel
            </Button>
            <Button
              type="submit"
              disabled={!canSubmit || createMutation.isPending}
              className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-6 shadow-sm flex items-center gap-1.5"
            >
              <Save className="h-4 w-4" />
              <span>
                {createMutation.isPending
                  ? 'Posting...'
                  : `Save & Post ${isReceipt ? 'Receipt' : 'Payment'}`}
              </span>
            </Button>
          </div>
        </div>
      </form>
    </div>
  );
};
