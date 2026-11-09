import React from 'react';
import { useFieldArray, useWatch } from 'react-hook-form';
import { Trash2, Plus } from 'lucide-react';
import { ItemCombobox } from './ItemCombobox';
import { Button } from '../ui/button';
import { Input } from '../ui/input';
import { calculateLineValues } from '../../lib/invoiceUtils';
import type { Item } from '../../types/item';

export interface InvoiceLineForm {
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
  priceField?: 'salePrice' | 'purchasePrice';
}

export const InvoiceLinesTable: React.FC<Props> = ({
  control,
  register,
  setValue,
  priceField = 'salePrice',
}) => {
  const { fields, append, remove } = useFieldArray({
    control,
    name: 'lines',
  });

  const lines = useWatch({ control, name: 'lines' }) as InvoiceLineForm[] | undefined;

  const handleItemSelect = (index: number, itemId: number, item?: Item) => {
    setValue(`lines.${index}.itemId`, itemId, { shouldValidate: true });
    if (item) {
      if (!lines?.[index]?.description || lines[index].description.trim() === '') {
        setValue(`lines.${index}.description`, item.name, { shouldValidate: true });
      }
      const price = priceField === 'purchasePrice' ? item.purchasePrice : item.salePrice;
      if (price !== null && price !== undefined) {
        setValue(`lines.${index}.unitPrice`, String(price), {
          shouldValidate: true,
        });
      }
    }
  };

  const handleNumericInput = (
    fieldName: string,
    raw: string,
    allowDecimal = true
  ) => {
    const cleaned = raw.replace(/,/g, '').trim();
    if (cleaned === '') {
      setValue(fieldName, '', { shouldValidate: true });
      return;
    }
    const regex = allowDecimal ? /^\d*(\.\d{0,4})?$/ : /^\d*$/;
    if (regex.test(cleaned)) {
      setValue(fieldName, cleaned, { shouldValidate: true });
    }
  };

  return (
    <div className="space-y-3">
      <div className="border border-paper-border rounded-md overflow-hidden bg-white shadow-subtle">
        <div className="overflow-x-auto">
          <table className="w-full text-xs border-collapse min-w-[760px]">
            <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
              <tr>
                <th className="w-10 px-2 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border">
                  #
                </th>
                <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-[28%]">
                  Item / SKU *
                </th>
                <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-[22%]">
                  Description
                </th>
                <th className="px-2 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-16">
                  Qty *
                </th>
                <th className="px-2 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-24">
                  Rate (NPR) *
                </th>
                <th className="px-2 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border w-20">
                  Tax Rate
                </th>
                <th className="px-2 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-24">
                  Tax
                </th>
                <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
                  Total (NPR)
                </th>
                <th className="w-10 px-2 py-2.5 font-serif uppercase tracking-wider text-center">
                  <span className="sr-only">Actions</span>
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-paper-border">
              {fields.map((field, index) => {
                const currentLine = lines?.[index] || {
                  itemId: null,
                  description: '',
                  quantity: '1',
                  unitPrice: '0',
                  taxRate: '13',
                };

                const { tax, total } = calculateLineValues(
                  currentLine.quantity,
                  currentLine.unitPrice,
                  currentLine.taxRate
                );

                return (
                  <tr
                    key={field.id}
                    className="hover:bg-paper-warm/30 transition-colors"
                  >
                    {/* Index */}
                    <td className="px-2 py-2 text-center text-paper-muted font-mono border-r border-paper-border">
                      {index + 1}
                    </td>

                    {/* Item Picker */}
                    <td className="px-2 py-1.5 border-r border-paper-border align-top">
                      <ItemCombobox
                        value={currentLine.itemId}
                        onChange={(id, item) =>
                          handleItemSelect(index, id, item)
                        }
                        placeholder="Select item..."
                      />
                    </td>

                    {/* Description */}
                    <td className="px-2 py-1.5 border-r border-paper-border align-top">
                      <Input
                        {...register(`lines.${index}.description`)}
                        placeholder="Item narration / spec"
                        className="text-xs h-9 bg-white"
                      />
                    </td>

                    {/* Quantity */}
                    <td className="px-2 py-1.5 border-r border-paper-border align-top">
                      <Input
                        value={currentLine.quantity}
                        onChange={(e) =>
                          handleNumericInput(
                            `lines.${index}.quantity`,
                            e.target.value,
                            true
                          )
                        }
                        placeholder="1"
                        className="text-xs h-9 text-right font-mono bg-white"
                      />
                    </td>

                    {/* Unit Price */}
                    <td className="px-2 py-1.5 border-r border-paper-border align-top">
                      <Input
                        value={currentLine.unitPrice}
                        onChange={(e) =>
                          handleNumericInput(
                            `lines.${index}.unitPrice`,
                            e.target.value,
                            true
                          )
                        }
                        placeholder="0.00"
                        className="text-xs h-9 text-right font-mono bg-white"
                      />
                    </td>

                    {/* Tax Rate % */}
                    <td className="px-2 py-1.5 border-r border-paper-border align-top">
                      <select
                        {...register(`lines.${index}.taxRate`)}
                        className="w-full h-9 rounded-sm border border-paper-border bg-white px-2 text-xs font-mono text-center focus:outline-none focus:ring-1 focus:ring-brand-navy"
                      >
                        <option value="0">0% (Exempt)</option>
                        <option value="5">5%</option>
                        <option value="12">12%</option>
                        <option value="13">13% (VAT)</option>
                        <option value="18">18%</option>
                        <option value="28">28%</option>
                      </select>
                    </td>

                    {/* Tax Amount (Calculated) */}
                    <td className="px-2 py-2 text-right font-mono text-paper-muted border-r border-paper-border select-none">
                      {tax}
                    </td>

                    {/* Line Total (Calculated) */}
                    <td className="px-3 py-2 text-right font-mono font-bold text-paper-text border-r border-paper-border select-none">
                      {total}
                    </td>

                    {/* Remove Action */}
                    <td className="px-2 py-2 text-center">
                      <button
                        type="button"
                        onClick={() => remove(index)}
                        disabled={fields.length <= 1}
                        title="Remove Line"
                        className="text-paper-muted hover:text-[#7a2e2e] disabled:opacity-30 disabled:cursor-not-allowed transition-colors p-1"
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {/* Add Row Bar */}
        <div className="bg-paper-alt/60 p-2.5 border-t border-paper-border flex items-center justify-between">
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() =>
              append({
                itemId: null,
                description: '',
                quantity: '1',
                unitPrice: '0',
                taxRate: '13',
              })
            }
            className="text-xs border-dashed border-paper-border hover:bg-paper-warm"
          >
            <Plus className="h-3.5 w-3.5 mr-1 text-brand-navy" />
            Add Line Item
          </Button>

          <span className="text-[11px] text-paper-muted italic hidden sm:inline">
            💡 Select item to auto-populate description & price, or enter custom details.
          </span>
        </div>
      </div>
    </div>
  );
};
