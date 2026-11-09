import React from 'react';
import { useFieldArray, useWatch } from 'react-hook-form';
import { Trash2, Plus } from 'lucide-react';
import { ItemCombobox } from '../invoices/ItemCombobox';
import { Input } from '../ui/input';
import { Button } from '../ui/button';
import { formatMoney } from '../../lib/invoiceUtils';
import { computeLineTotals } from '../../lib/noteUtils';
import type { Item } from '../../types/item';

export interface NoteLineForm {
  itemId: number | null;
  description: string;
  quantity: string;
  unitPrice: string;
  taxRate: string;
}

interface Props {
  control: any;
  register: any;
  setValue: any;
}

const TAX_RATES = ['0', '0.05', '0.12', '0.13', '0.18', '0.28'];

export const CreditNoteLinesTable: React.FC<Props> = ({ control, register, setValue }) => {
  const { fields, append, remove } = useFieldArray({ control, name: 'lines' });
  const lines = useWatch({ control, name: 'lines' }) as NoteLineForm[] | undefined;

  const handleItemSelect = (index: number, itemId: number, item?: Item) => {
    setValue(`lines.${index}.itemId`, itemId, { shouldValidate: true });
    if (item) {
      if (!lines?.[index]?.description || lines[index].description.trim() === '') {
        setValue(`lines.${index}.description`, item.name, { shouldValidate: true });
      }
      if (item.salePrice !== null && item.salePrice !== undefined) {
        setValue(`lines.${index}.unitPrice`, String(item.salePrice), { shouldValidate: true });
      }
    }
  };

  return (
    <div>
      <div className="overflow-x-auto border border-paper-border rounded-md shadow-sm">
        <table className="w-full text-sm border-collapse bg-white">
          <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-brand-navy">
            <tr>
              <th className="w-10 px-2 py-2.5 text-xs font-serif uppercase tracking-wider text-center text-paper-muted">#</th>
              <th className="px-3 py-2.5 text-xs font-serif uppercase tracking-wider text-left text-paper-muted">Item / Description</th>
              <th className="px-2 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-24">Qty</th>
              <th className="px-2 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-28">Rate (₹)</th>
              <th className="px-2 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-24">VAT / Tax</th>
              <th className="px-3 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-28">Subtotal</th>
              <th className="px-3 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-24">Tax</th>
              <th className="px-3 py-2.5 text-xs font-serif uppercase tracking-wider text-right text-paper-muted w-28">Total</th>
              <th className="w-10"></th>
            </tr>
          </thead>
          <tbody className="divide-y divide-paper-border">
            {fields.map((field, index) => {
              const line = lines?.[index] ?? {
                quantity: '',
                unitPrice: '',
                taxRate: '0',
                itemId: null,
                description: '',
              };
              const totals = computeLineTotals(
                line.quantity ?? '',
                line.unitPrice ?? '',
                line.taxRate ?? '0'
              );

              return (
                <tr key={field.id} className="hover:bg-paper-alt/40 transition-colors">
                  <td className="text-center text-xs font-mono text-paper-muted px-2 py-2">
                    {index + 1}
                  </td>
                  <td className="px-3 py-2">
                    <ItemCombobox
                      value={line.itemId ?? null}
                      onChange={(id, item) => handleItemSelect(index, id, item)}
                    />
                    <Input
                      className="mt-1 text-xs h-7 bg-transparent border-dashed focus:border-solid"
                      placeholder="Line item description / return note"
                      {...register(`lines.${index}.description`)}
                    />
                  </td>
                  <td className="px-2 py-2">
                    <Input
                      className="text-right font-mono text-xs h-9"
                      {...register(`lines.${index}.quantity`)}
                      placeholder="0"
                    />
                  </td>
                  <td className="px-2 py-2">
                    <Input
                      className="text-right font-mono text-xs h-9"
                      {...register(`lines.${index}.unitPrice`)}
                      placeholder="0.00"
                    />
                  </td>
                  <td className="px-2 py-2">
                    <select
                      className="w-full px-2 py-1.5 text-xs font-mono border border-paper-border-strong rounded bg-white text-brand-navy focus:outline-none focus:ring-1 focus:ring-brand-navy"
                      {...register(`lines.${index}.taxRate`)}
                    >
                      {TAX_RATES.map((r) => (
                        <option key={r} value={r}>
                          {(parseFloat(r) * 100).toFixed(0)}%
                        </option>
                      ))}
                    </select>
                  </td>
                  <td className="px-3 py-2 text-right font-mono tabular-nums text-xs text-paper-text">
                    {totals.lineSubtotal !== '0.0000' ? formatMoney(totals.lineSubtotal) : '—'}
                  </td>
                  <td className="px-3 py-2 text-right font-mono tabular-nums text-xs text-paper-muted">
                    {totals.lineTax !== '0.0000' ? formatMoney(totals.lineTax) : '—'}
                  </td>
                  <td className="px-3 py-2 text-right font-mono tabular-nums text-xs font-semibold text-brand-navy">
                    {totals.lineTotal !== '0.0000' ? formatMoney(totals.lineTotal) : '—'}
                  </td>
                  <td className="text-center px-1">
                    <button
                      type="button"
                      onClick={() => fields.length > 1 && remove(index)}
                      disabled={fields.length <= 1}
                      className="p-1 text-paper-muted hover:text-brand-burgundy hover:bg-rose-50 rounded disabled:opacity-20 transition-colors"
                      title="Remove line"
                    >
                      <Trash2 size={14} />
                    </button>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      <Button
        type="button"
        variant="outline"
        size="sm"
        className="mt-3 border-paper-border text-brand-navy hover:bg-paper-alt font-serif text-xs"
        onClick={() => append({ itemId: null, description: '', quantity: '', unitPrice: '', taxRate: '0' })}
      >
        <Plus size={14} className="mr-1" /> Add Line
      </Button>
    </div>
  );
};
