import React, { useEffect, useMemo } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useForm, useWatch } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { toast } from 'sonner';
import { ArrowLeft, RotateCcw, AlertCircle } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { Select } from '../../components/ui/select';
import { VendorCombobox } from '../../components/invoices/VendorCombobox';
import { DebitNoteLinesTable } from '../../components/debitnote/DebitNoteLinesTable';
import { useCreateDebitNote, useDebitNotes } from '../../hooks/useDebitNotes';
import { usePurchaseInvoices } from '../../hooks/usePurchaseInvoices';
import { generateDebitNoteNumber, computeLineTotals } from '../../lib/noteUtils';
import { formatMoney } from '../../lib/invoiceUtils';

const lineSchema = z.object({
  itemId: z.number().nullable(),
  description: z.string().optional(),
  quantity: z.string().min(1, 'Quantity required'),
  unitPrice: z.string().min(1, 'Price required'),
  taxRate: z.string().min(1, 'Tax rate required'),
});

const schema = z.object({
  debitNoteNumber: z.string().min(1, 'Debit note number is required'),
  debitNoteDate: z.string().min(1, 'Date is required'),
  vendorId: z.number().int().positive('Vendor is required'),
  originalInvoiceId: z.number().nullable(),
  reason: z.string().optional(),
  lines: z.array(lineSchema).min(1, 'At least one line is required'),
});

type FormData = z.infer<typeof schema>;

export const DebitNoteFormPage: React.FC = () => {
  const navigate = useNavigate();
  const createMutation = useCreateDebitNote();
  const { data: existing = [] } = useDebitNotes({ limit: 100 });

  const suggestedNumber = useMemo(
    () => generateDebitNoteNumber(existing.map((n) => n.debitNoteNumber)),
    [existing]
  );

  const {
    control,
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      debitNoteNumber: suggestedNumber,
      debitNoteDate: new Date().toISOString().slice(0, 10),
      vendorId: 0,
      originalInvoiceId: null,
      reason: '',
      lines: [
        {
          itemId: null,
          description: '',
          quantity: '',
          unitPrice: '',
          taxRate: '0.13', // default 13% VAT
        },
      ],
    },
  });

  // Keep number updated if suggestions load after initial mount
  useEffect(() => {
    if (suggestedNumber) {
      const current = watch('debitNoteNumber');
      if (!current || current === 'DN-2026-0001') {
        setValue('debitNoteNumber', suggestedNumber);
      }
    }
  }, [suggestedNumber, setValue, watch]);

  const vendorId = watch('vendorId');
  const originalInvoiceId = watch('originalInvoiceId');

  const { invoices = [] } = usePurchaseInvoices({
    vendorId: vendorId || undefined,
    status: 'POSTED',
    limit: 100,
  });

  const lines = useWatch({ control, name: 'lines' }) ?? [];

  const totals = useMemo(() => {
    let sub = 0;
    let tax = 0;
    let total = 0;
    for (const l of lines) {
      const t = computeLineTotals(l.quantity, l.unitPrice, l.taxRate);
      sub += parseFloat(t.lineSubtotal);
      tax += parseFloat(t.lineTax);
      total += parseFloat(t.lineTotal);
    }
    return { sub, tax, total };
  }, [lines]);

  const onSubmit = async (data: FormData) => {
    if (totals.total <= 0) {
      toast.error('Debit note total must be greater than zero');
      return;
    }

    try {
      const dn = await createMutation.mutateAsync({
        debitNoteNumber: data.debitNoteNumber.trim(),
        debitNoteDate: data.debitNoteDate,
        vendorId: data.vendorId,
        originalInvoiceId: data.originalInvoiceId || undefined,
        reason: data.reason?.trim() || undefined,
        lines: data.lines.map((l) => ({
          itemId: l.itemId,
          description: l.description?.trim() || undefined,
          quantity: l.quantity,
          unitPrice: l.unitPrice,
          taxRate: l.taxRate,
        })),
      });
      navigate(`/debit-notes/${dn.id}`);
    } catch {
      // Error handled in hook toast
    }
  };

  return (
    <div className="p-6 max-w-6xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <Link
            to="/debit-notes"
            className="text-xs font-serif text-paper-muted hover:text-brand-navy flex items-center gap-1 mb-1 transition-colors"
          >
            <ArrowLeft size={12} /> Back to Debit Notes
          </Link>
          <div className="flex items-center gap-2">
            <h1 className="font-serif text-2xl font-bold text-brand-navy">
              New Debit Note
            </h1>
            <span className="text-xs px-2 py-0.5 rounded bg-amber-500/10 text-amber-800 font-serif uppercase tracking-wider font-semibold border border-amber-500/20">
              Purchase Return
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-1">
            Record supplier goods return, vendor price correction, or purchase allowance with automated ledger debit to AP.
          </p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Document Header Card */}
        <div className="bg-white border border-paper-border rounded-lg p-5 shadow-sm space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <Label className="text-xs font-serif text-brand-navy">Debit Note # *</Label>
              <Input
                {...register('debitNoteNumber')}
                className="font-mono text-sm h-9"
                placeholder="DN-YYYY-XXXX"
              />
              {errors.debitNoteNumber && (
                <p className="text-xs text-ledger-red mt-1">{errors.debitNoteNumber.message}</p>
              )}
            </div>

            <div>
              <Label className="text-xs font-serif text-brand-navy">Date *</Label>
              <Input
                type="date"
                {...register('debitNoteDate')}
                className="font-mono text-sm h-9"
              />
              {errors.debitNoteDate && (
                <p className="text-xs text-ledger-red mt-1">{errors.debitNoteDate.message}</p>
              )}
            </div>

            <div className="md:col-span-2">
              <Label className="text-xs font-serif text-brand-navy">Vendor / Supplier *</Label>
              <VendorCombobox
                value={vendorId || null}
                onChange={(id) => {
                  setValue('vendorId', id ?? 0, { shouldValidate: true });
                  setValue('originalInvoiceId', null);
                }}
              />
              {errors.vendorId && (
                <p className="text-xs text-ledger-red mt-1">{errors.vendorId.message}</p>
              )}
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2 border-t border-paper-border">
            <div>
              <Label className="text-xs font-serif text-brand-navy">Original Purchase Bill (Optional)</Label>
              <Select
                value={originalInvoiceId ?? ''}
                onChange={(e) =>
                  setValue(
                    'originalInvoiceId',
                    e.target.value ? Number(e.target.value) : null
                  )
                }
                disabled={!vendorId}
              >
                <option value="">— Standalone debit note (Unlinked) —</option>
                {invoices.map((inv) => (
                  <option key={inv.id} value={inv.id}>
                    {inv.invoiceNumber} · {inv.invoiceDate} (Total: {formatMoney(inv.totalAmount)})
                  </option>
                ))}
              </Select>
              <p className="text-[11px] text-paper-muted mt-1">
                If linked, the debit note reduces this purchase bill's outstanding payable in Accounts Payable.
              </p>
            </div>

            <div>
              <Label className="text-xs font-serif text-brand-navy">Return Reason</Label>
              <Input
                {...register('reason')}
                className="text-sm h-9"
                placeholder="e.g. Defective raw material, vendor price revision, incorrect specs received"
              />
            </div>
          </div>
        </div>

        {/* Lines Table Card */}
        <div className="bg-white border border-paper-border rounded-lg p-5 shadow-sm space-y-3">
          <div className="flex items-center justify-between">
            <h3 className="font-serif text-sm font-semibold text-brand-navy">
              Return Line Items
            </h3>
            <span className="text-xs text-paper-muted font-serif">
              Reverses vendor purchase amount and input tax claim
            </span>
          </div>

          <DebitNoteLinesTable control={control} register={register} setValue={setValue} />
          {errors.lines && (
            <p className="text-xs text-ledger-red mt-1">{errors.lines.message}</p>
          )}
        </div>

        {/* Totals & Financial Summary Card */}
        <div className="bg-white border border-paper-border rounded-lg p-5 shadow-sm">
          <div className="max-w-md ml-auto text-sm space-y-2">
            <div className="flex justify-between text-paper-muted text-xs">
              <span className="font-serif">Subtotal (Net Return)</span>
              <span className="font-mono tabular-nums">{formatMoney(totals.sub.toFixed(2))}</span>
            </div>
            <div className="flex justify-between text-paper-muted text-xs">
              <span className="font-serif">VAT / Input Tax Reversed</span>
              <span className="font-mono tabular-nums">{formatMoney(totals.tax.toFixed(2))}</span>
            </div>
            <div className="flex justify-between border-t-2 border-double border-paper-border-strong pt-2 mt-2 font-bold text-base text-brand-navy">
              <span className="font-serif">Total Debit Amount</span>
              <span className="font-mono tabular-nums text-emerald-700">
                {formatMoney(totals.total.toFixed(2))}
              </span>
            </div>
          </div>
        </div>

        {/* Action Bar */}
        <div className="sticky bottom-4 bg-white/95 backdrop-blur-sm border border-paper-border rounded-lg p-4 flex flex-col sm:flex-row justify-between items-center shadow-lg gap-3">
          <div className="flex items-center gap-2 text-xs text-paper-muted">
            <AlertCircle size={15} className="text-emerald-700 shrink-0" />
            <span>
              Posting creates automated GL voucher: <strong className="text-brand-navy">Accounts Payable (Dr)</strong>,{' '}
              <strong className="text-brand-navy">Purchase Returns (Cr)</strong>, and{' '}
              <strong className="text-brand-navy">VAT Input (Cr)</strong>.
            </span>
          </div>

          <div className="flex items-center gap-2 w-full sm:w-auto justify-end">
            <Button
              type="button"
              variant="outline"
              onClick={() => navigate('/debit-notes')}
              className="border-paper-border text-brand-navy hover:bg-paper-alt font-serif text-xs"
            >
              Cancel
            </Button>
            <Button
              type="submit"
              disabled={createMutation.isPending || totals.total <= 0}
              className="bg-emerald-700 hover:bg-emerald-800 text-white font-serif text-xs px-5 flex items-center gap-1.5"
            >
              <RotateCcw size={14} />
              {createMutation.isPending ? 'Posting Voucher...' : 'Post Debit Note'}
            </Button>
          </div>
        </div>
      </form>
    </div>
  );
};

