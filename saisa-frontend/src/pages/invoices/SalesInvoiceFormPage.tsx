import React, { useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { ArrowLeft, Save, FileText, CheckCircle2 } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { CustomerCombobox } from '../../components/invoices/CustomerCombobox';
import {
  InvoiceLinesTable,
  type InvoiceLineForm,
} from '../../components/invoices/InvoiceLinesTable';
import { InvoiceTotalsCard } from '../../components/invoices/InvoiceTotalsCard';
import { useCreateSalesInvoice } from '../../hooks/useSalesInvoices';
import { useWarehouses } from '../../hooks/useWarehouses';
import { useCustomers } from '../../hooks/useCustomers';
import { generateInvoiceNumber } from '../../lib/invoiceUtils';
import type { CreateSalesInvoiceRequest } from '../../types/salesInvoice';

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
  invoiceNumber: z.string().min(1, 'Invoice number is required'),
  invoiceDate: z.string().min(1, 'Invoice date is required'),
  dueDate: z.string().optional(),
  customerId: z.number({ required_error: 'Please select a customer' }),
  warehouseId: z.number().nullable().optional(),
  notes: z.string().optional(),
  lines: z.array(lineSchema).min(1, 'At least one line item is required'),
});

type FormData = z.infer<typeof schema>;

export const SalesInvoiceFormPage: React.FC = () => {
  const navigate = useNavigate();
  const createMutation = useCreateSalesInvoice();
  const { warehouses = [] } = useWarehouses();
  const { customers = [] } = useCustomers();

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
      invoiceNumber: generateInvoiceNumber('INV'),
      invoiceDate: today,
      dueDate: due30,
      customerId: undefined as any,
      warehouseId: defaultWh ? defaultWh.id : null,
      notes: 'Payment due within 30 days of invoice date.',
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

  const selectedCustomerId = watch('customerId');
  const watchedLines = watch('lines') as InvoiceLineForm[];

  const selectedCustomer = useMemo(
    () => customers.find((c) => c.id === selectedCustomerId),
    [customers, selectedCustomerId]
  );

  const onSubmit = async (data: FormData) => {
    try {
      const payload: CreateSalesInvoiceRequest = {
        invoiceNumber: data.invoiceNumber.trim(),
        invoiceDate: data.invoiceDate,
        dueDate: data.dueDate || undefined,
        customerId: data.customerId,
        warehouseId: data.warehouseId ? Number(data.warehouseId) : undefined,
        notes: data.notes?.trim() || undefined,
        idempotencyKey: `inv-${data.invoiceNumber.trim()}-${Date.now()}`,
        lines: data.lines.map((l) => ({
          itemId: l.itemId ? Number(l.itemId) : undefined,
          description: l.description?.trim() || undefined,
          quantity: l.quantity,
          unitPrice: l.unitPrice,
          taxRate: l.taxRate,
        })),
      };

      await createMutation.mutateAsync(payload);
      navigate('/invoices');
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
            onClick={() => navigate('/invoices')}
            className="h-8 px-2 text-paper-muted hover:text-paper-text border-paper-border"
          >
            <ArrowLeft className="h-4 w-4 mr-1" />
            <span className="text-xs">Invoices</span>
          </Button>

          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-xl font-serif font-bold text-brand-navy">
                New Sales Tax Invoice
              </h1>
              <span className="key-tag text-[10px] bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border text-paper-muted">
                F8
              </span>
            </div>
            <p className="text-xs text-paper-muted mt-0.5">
              Generate VAT compliant sales invoice with automatic ledger posting and COGS movement.
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={() => navigate('/invoices')}
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
              'Posting Invoice...'
            ) : (
              <>
                <CheckCircle2 className="h-4 w-4" />
                <span>Post & Issue Invoice</span>
              </>
            )}
          </Button>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
        {/* Invoice Header Details Box */}
        <div className="bg-white border border-paper-border rounded-md p-4 shadow-subtle space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            {/* Customer Picker */}
            <div className="md:col-span-2 space-y-1">
              <Label className="text-xs font-serif font-bold text-paper-text flex items-center justify-between">
                <span>Customer / Billed To *</span>
              </Label>
              <CustomerCombobox
                value={selectedCustomerId}
                onChange={(id) => setValue('customerId', id, { shouldValidate: true })}
                error={errors.customerId?.message}
              />
              {errors.customerId && (
                <p className="text-[11px] text-[#7a2e2e]">
                  {errors.customerId.message}
                </p>
              )}

              {/* Selected Customer Details preview */}
              {selectedCustomer && (
                <div className="mt-2 p-2 bg-paper-alt/50 border border-paper-border/70 rounded text-[11px] text-paper-muted space-y-0.5">
                  <div className="font-semibold text-paper-text">
                    {selectedCustomer.customerName}
                  </div>
                  <div className="flex flex-wrap gap-x-3 text-[10px]">
                    {selectedCustomer.pan && <span>PAN/VAT: {selectedCustomer.pan}</span>}
                    {selectedCustomer.phone && <span>Ph: {selectedCustomer.phone}</span>}
                    {selectedCustomer.state && <span>State: {selectedCustomer.state}</span>}
                  </div>
                  {selectedCustomer.billingAddress && (
                    <div className="text-[10px] text-paper-muted italic truncate">
                      {selectedCustomer.billingAddress}
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Invoice Number */}
            <div className="space-y-1">
              <Label className="text-xs font-serif font-bold text-paper-text">
                Invoice Number *
              </Label>
              <Input
                {...register('invoiceNumber')}
                placeholder="INV-202611-0001"
                className="font-mono text-xs h-9 bg-white"
              />
              {errors.invoiceNumber && (
                <p className="text-[11px] text-[#7a2e2e]">
                  {errors.invoiceNumber.message}
                </p>
              )}
            </div>

            {/* Warehouse */}
            <div className="space-y-1">
              <Label className="text-xs font-serif font-bold text-paper-text">
                Dispatch Warehouse
              </Label>
              <select
                {...register('warehouseId', { valueAsNumber: true })}
                className="w-full h-9 rounded-sm border border-paper-border bg-white px-2.5 text-xs focus:outline-none focus:ring-1 focus:ring-brand-navy"
              >
                <option value="">(None / Direct Service)</option>
                {warehouses.map((w) => (
                  <option key={w.id} value={w.id}>
                    {w.name} {w.defaultWarehouse ? '★ (Main)' : ''}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 pt-1 border-t border-paper-border/60">
            {/* Invoice Date */}
            <div className="space-y-1">
              <Label className="text-xs font-serif text-paper-text">
                Invoice Date *
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
              <Label className="text-xs font-serif text-paper-text">Due Date</Label>
              <Input
                type="date"
                {...register('dueDate')}
                className="font-mono text-xs h-9 bg-white"
              />
            </div>

            {/* Notes / Terms */}
            <div className="md:col-span-2 space-y-1">
              <Label className="text-xs font-serif text-paper-text">
                Payment Terms / Invoice Notes
              </Label>
              <Input
                {...register('notes')}
                placeholder="e.g. Due on receipt, Bank transfer to Prabhu Bank"
                className="text-xs h-9 bg-white"
              />
            </div>
          </div>
        </div>

        {/* Invoice Lines Table */}
        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <h2 className="text-xs font-serif font-bold text-brand-navy uppercase tracking-wider flex items-center gap-1.5">
              <FileText className="h-3.5 w-3.5" />
              Invoice Particulars & Line Items
            </h2>
            <span className="text-[11px] text-paper-muted">
              {watchedLines?.length || 0} line(s) added
            </span>
          </div>

          <InvoiceLinesTable
            control={control}
            register={register}
            setValue={setValue}
          />
        </div>

        {/* Bottom Section: Totals Card + Summary */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 pt-2">
          <div className="md:col-span-2 space-y-3">
            <div className="bg-paper-alt/40 border border-paper-border rounded-md p-4 text-xs space-y-2">
              <h3 className="font-serif font-bold text-paper-text uppercase text-[11px] tracking-wide">
                Tax & Legal Compliance
              </h3>
              <ul className="list-disc list-inside space-y-1 text-paper-muted text-[11px]">
                <li>
                  Invoice conforms to VAT Rules & Schedule for tax invoices.
                </li>
                <li>
                  Saving will generate an official Journal Voucher in Accounts Receivable.
                </li>
                <li>
                  Tracked items will update stock balances for the chosen warehouse in real time.
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
            onClick={() => navigate('/invoices')}
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
            <span>{createMutation.isPending ? 'Posting...' : 'Save & Post Invoice'}</span>
          </Button>
        </div>
      </form>
    </div>
  );
};
