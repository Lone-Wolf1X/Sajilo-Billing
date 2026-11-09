import React, { useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { ArrowLeft, Save, FileText, CheckCircle2 } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { VendorCombobox } from '../../components/invoices/VendorCombobox';
import {
  InvoiceLinesTable,
  type InvoiceLineForm,
} from '../../components/invoices/InvoiceLinesTable';
import { InvoiceTotalsCard } from '../../components/invoices/InvoiceTotalsCard';
import { useCreatePurchaseInvoice } from '../../hooks/usePurchaseInvoices';
import { useWarehouses } from '../../hooks/useWarehouses';
import { useVendors } from '../../hooks/useVendors';
import { generateInvoiceNumber } from '../../lib/invoiceUtils';
import type { CreatePurchaseInvoiceRequest } from '../../types/purchaseInvoice';

const lineSchema = z.object({
  itemId: z.number().nullable().optional(),
  description: z.string().optional(),
  quantity: z.string().refine((v) => parseFloat(v) > 0, {
    message: 'Quantity must be greater than 0',
  }),
  unitPrice: z.string().refine((v) => parseFloat(v) >= 0, {
    message: 'Price must be non-negative',
  }),
  taxRate: z.string(),
});

const schema = z.object({
  invoiceNumber: z.string().min(1, 'Bill number is required'),
  vendorInvoiceNo: z.string().optional(),
  invoiceDate: z.string().min(1, 'Bill date is required'),
  dueDate: z.string().optional(),
  vendorId: z.number({ required_error: 'Please select a supplier / vendor' }),
  warehouseId: z.number().nullable().optional(),
  notes: z.string().optional(),
  lines: z.array(lineSchema).min(1, 'At least one line item is required'),
});

type FormData = z.infer<typeof schema>;

export const PurchaseInvoiceFormPage: React.FC = () => {
  const navigate = useNavigate();
  const createMutation = useCreatePurchaseInvoice();
  const { warehouses = [] } = useWarehouses();
  const { vendors = [] } = useVendors();

  // Calculate default dates
  const today = useMemo(() => new Date().toISOString().split('T')[0], []);
  const due30 = useMemo(() => {
    const d = new Date();
    d.setDate(d.getDate() + 30);
    return d.toISOString().split('T')[0];
  }, []);

  const defaultWh = useMemo(
    () => warehouses.find((w) => w.defaultWarehouse) || warehouses[0],
    [warehouses]
  );

  const {
    register,
    control,
    handleSubmit,
    watch,
    setValue,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      invoiceNumber: generateInvoiceNumber('PUR'),
      vendorInvoiceNo: '',
      invoiceDate: today,
      dueDate: due30,
      vendorId: undefined as any,
      warehouseId: defaultWh ? defaultWh.id : null,
      notes: 'Purchase order received and inspected.',
      lines: [
        {
          itemId: null,
          description: '',
          quantity: '1',
          unitPrice: '0',
          taxRate: '13',
        },
      ],
    },
  });

  const selectedVendorId = watch('vendorId');
  const watchedLines = watch('lines') as InvoiceLineForm[];

  const selectedVendor = useMemo(
    () => vendors.find((v) => v.id === selectedVendorId),
    [vendors, selectedVendorId]
  );

  const onSubmit = async (data: FormData) => {
    try {
      const payload: CreatePurchaseInvoiceRequest = {
        invoiceNumber: data.invoiceNumber.trim(),
        vendorInvoiceNo: data.vendorInvoiceNo?.trim() || undefined,
        invoiceDate: data.invoiceDate,
        dueDate: data.dueDate || undefined,
        vendorId: data.vendorId,
        warehouseId: data.warehouseId ? Number(data.warehouseId) : undefined,
        notes: data.notes?.trim() || undefined,
        idempotencyKey: `pur-${data.invoiceNumber.trim()}-${Date.now()}`,
        lines: data.lines.map((l) => ({
          itemId: l.itemId ? Number(l.itemId) : undefined,
          description: l.description?.trim() || undefined,
          quantity: l.quantity,
          unitPrice: l.unitPrice,
          taxRate: l.taxRate,
        })),
      };

      await createMutation.mutateAsync(payload);
      navigate('/purchase-invoices');
    } catch {
      // toast is already handled by hook
    }
  };

  return (
    <div className="space-y-5 max-w-6xl mx-auto pb-12">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-paper-border pb-4">
        <div className="flex items-center gap-3">
          <Button
            variant="outline"
            size="sm"
            onClick={() => navigate('/purchase-invoices')}
            className="h-8 px-2 text-paper-muted hover:text-paper-text border-paper-border"
          >
            <ArrowLeft className="h-4 w-4 mr-1" />
            <span className="text-xs">Purchase Bills</span>
          </Button>

          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-xl font-serif font-bold text-brand-navy">
                New Purchase Bill (Invoice)
              </h1>
              <span className="key-tag text-[10px] bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border text-paper-muted">
                F9
              </span>
            </div>
            <p className="text-xs text-paper-muted mt-0.5">
              Record supplier bill, input tax credit (VAT), and automatic stock intake.
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={() => navigate('/purchase-invoices')}
            className="text-xs border-paper-border"
          >
            Cancel
          </Button>

          <Button
            type="button"
            onClick={handleSubmit(onSubmit)}
            disabled={createMutation.isPending}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4 shadow-sm flex items-center gap-1.5"
          >
            {createMutation.isPending ? (
              'Posting Bill...'
            ) : (
              <>
                <CheckCircle2 className="h-4 w-4" />
                <span>Post & Record Bill</span>
              </>
            )}
          </Button>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
        {/* Header Details Box */}
        <div className="bg-white border border-paper-border rounded-md p-4 shadow-subtle space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            {/* Vendor Picker */}
            <div className="md:col-span-2 space-y-1">
              <Label className="text-xs font-serif font-bold text-paper-text">
                Supplier / Vendor *
              </Label>
              <VendorCombobox
                value={selectedVendorId}
                onChange={(id) => setValue('vendorId', id, { shouldValidate: true })}
                error={errors.vendorId?.message}
              />
              {errors.vendorId && (
                <p className="text-[11px] text-[#7a2e2e]">
                  {errors.vendorId.message}
                </p>
              )}

              {/* Selected Vendor Preview */}
              {selectedVendor && (
                <div className="mt-2 p-2 bg-paper-alt/50 border border-paper-border/70 rounded text-[11px] text-paper-muted space-y-0.5">
                  <div className="font-semibold text-paper-text">
                    {selectedVendor.vendorName}
                  </div>
                  <div className="flex flex-wrap gap-x-3 text-[10px]">
                    {selectedVendor.pan && <span>PAN/VAT: {selectedVendor.pan}</span>}
                    {selectedVendor.phone && <span>Ph: {selectedVendor.phone}</span>}
                    {selectedVendor.state && <span>State: {selectedVendor.state}</span>}
                  </div>
                  {selectedVendor.billingAddress && (
                    <div className="text-[10px] text-paper-muted italic truncate">
                      {selectedVendor.billingAddress}
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Internal Bill Reference */}
            <div className="space-y-1">
              <Label className="text-xs font-serif font-bold text-paper-text">
                Internal Bill # *
              </Label>
              <Input
                {...register('invoiceNumber')}
                placeholder="PUR-202611-0001"
                className="font-mono text-xs h-9 bg-white"
              />
              {errors.invoiceNumber && (
                <p className="text-[11px] text-[#7a2e2e]">
                  {errors.invoiceNumber.message}
                </p>
              )}
            </div>

            {/* Supplier Bill / Inv No */}
            <div className="space-y-1">
              <Label className="text-xs font-serif font-bold text-paper-text">
                Supplier Bill / Invoice #
              </Label>
              <Input
                {...register('vendorInvoiceNo')}
                placeholder="e.g. VEN-INV-8491"
                className="font-mono text-xs h-9 bg-white"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 pt-1 border-t border-paper-border/60">
            {/* Bill Date */}
            <div className="space-y-1">
              <Label className="text-xs font-serif text-paper-text">
                Bill Date *
              </Label>
              <Input
                type="date"
                {...register('invoiceDate')}
                className="font-mono text-xs h-9 bg-white"
              />
              {errors.invoiceDate && (
                <p className="text-[11px] text-[#7a2e2e]">
                  {errors.invoiceDate.message}
                </p>
              )}
            </div>

            {/* Due Date */}
            <div className="space-y-1">
              <Label className="text-xs font-serif text-paper-text">Payment Due Date</Label>
              <Input
                type="date"
                {...register('dueDate')}
                className="font-mono text-xs h-9 bg-white"
              />
            </div>

            {/* Receiving Warehouse */}
            <div className="space-y-1">
              <Label className="text-xs font-serif text-paper-text">
                Receiving Warehouse
              </Label>
              <select
                {...register('warehouseId', { valueAsNumber: true })}
                className="w-full h-9 rounded-sm border border-paper-border bg-white px-2.5 text-xs focus:outline-none focus:ring-1 focus:ring-brand-navy"
              >
                <option value="">(None / Direct Expense)</option>
                {warehouses.map((w) => (
                  <option key={w.id} value={w.id}>
                    {w.name} {w.defaultWarehouse ? '★ (Main)' : ''}
                  </option>
                ))}
              </select>
            </div>

            {/* Notes */}
            <div className="space-y-1">
              <Label className="text-xs font-serif text-paper-text">
                PO / Delivery Reference
              </Label>
              <Input
                {...register('notes')}
                placeholder="e.g. Challan #9921, Gate pass received"
                className="text-xs h-9 bg-white"
              />
            </div>
          </div>
        </div>

        {/* Line Items Table */}
        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <h2 className="text-xs font-serif font-bold text-brand-navy uppercase tracking-wider flex items-center gap-1.5">
              <FileText className="h-3.5 w-3.5" />
              Bill Particulars & Itemized Stock
            </h2>
            <span className="text-[11px] text-paper-muted">
              {watchedLines?.length || 0} line(s) added
            </span>
          </div>

          <InvoiceLinesTable
            control={control}
            register={register}
            setValue={setValue}
            priceField="purchasePrice"
          />
        </div>

        {/* Bottom Section: Totals Card */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 pt-2">
          <div className="md:col-span-2 space-y-3">
            <div className="bg-paper-alt/40 border border-paper-border rounded-md p-4 text-xs space-y-2">
              <h3 className="font-serif font-bold text-paper-text uppercase text-[11px] tracking-wide">
                Purchasing & Accounts Payable Impact
              </h3>
              <ul className="list-disc list-inside space-y-1 text-paper-muted text-[11px]">
                <li>
                  Posts a debit to Inventory / Expense and credit to Accounts Payable (Vendor Account).
                </li>
                <li>
                  VAT paid is credited to Input VAT account for monthly VAT return adjustment.
                </li>
                <li>
                  Inventory item stock quantities and average cost (FIFO) are automatically updated.
                </li>
              </ul>
            </div>
          </div>

          <div className="md:col-span-1">
            <InvoiceTotalsCard lines={watchedLines || []} />
          </div>
        </div>

        {/* Bottom Submit Bar */}
        <div className="flex items-center justify-end gap-3 pt-4 border-t border-paper-border">
          <Button
            type="button"
            variant="outline"
            onClick={() => navigate('/purchase-invoices')}
            className="text-xs border-paper-border"
          >
            Cancel
          </Button>
          <Button
            type="submit"
            disabled={createMutation.isPending}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-6 shadow-sm flex items-center gap-1.5"
          >
            <Save className="h-4 w-4" />
            <span>{createMutation.isPending ? 'Posting...' : 'Save & Record Purchase Bill'}</span>
          </Button>
        </div>
      </form>
    </div>
  );
};
