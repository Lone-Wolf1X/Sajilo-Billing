import React from 'react';
import {
  useFieldArray,
  useWatch,
} from 'react-hook-form';
import { Trash2, Plus } from 'lucide-react';
import { AccountCombobox } from './AccountCombobox';
import { Button } from '../ui/button';

export interface LineForm {
  accountId: number | null;
  side: 'DEBIT' | 'CREDIT';
  amount: string;
  description?: string;
}

interface Props {
  control: any;
  register: any;
  setValue: any;
}

export const JournalLinesTable: React.FC<Props> = ({
  control,
  register,
  setValue,
}) => {
  const { fields, append, remove } = useFieldArray({
    control,
    name: 'lines',
  });

  const lines = useWatch({ control, name: 'lines' }) as LineForm[] | undefined;

  const handleAmountChange = (
    index: number,
    side: 'DEBIT' | 'CREDIT',
    raw: string
  ) => {
    const cleaned = raw.replace(/,/g, '').trim();
    // Allow digits and up to 4 decimal places
    if (cleaned !== '' && !/^\d*(\.\d{0,4})?$/.test(cleaned)) {
      return;
    }

    setValue(`lines.${index}.amount`, cleaned, { shouldValidate: true });
    setValue(`lines.${index}.side`, side, { shouldValidate: true });
  };

  return (
    <div className="space-y-3">
      <div className="border border-paper-border rounded-md overflow-hidden bg-white shadow-subtle">
        <table className="w-full text-xs border-collapse">
          <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
            <tr>
              <th className="w-10 px-2 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border">
                #
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-[38%]">
                Ledger Account *
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
                Line Narration / Memo
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-36">
                Debit (₹)
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-36">
                Credit (₹)
              </th>
              <th className="w-10 px-2 py-2.5 text-center"></th>
            </tr>
          </thead>
          <tbody className="divide-y divide-paper-border">
            {fields.map((field, index) => {
              const line = lines?.[index] ?? {
                accountId: null,
                side: 'DEBIT',
                amount: '',
                description: '',
              };

              const debitValue = line.side === 'DEBIT' ? line.amount : '';
              const creditValue = line.side === 'CREDIT' ? line.amount : '';

              return (
                <tr
                  key={field.id}
                  className="hover:bg-paper-hover/40 transition-colors"
                >
                  {/* Line Number */}
                  <td className="text-center font-mono text-[11px] text-paper-muted py-2 px-1 border-r border-paper-border bg-paper-alt/30">
                    {index + 1}
                  </td>

                  {/* Account Combobox */}
                  <td className="p-1.5 border-r border-paper-border">
                    <AccountCombobox
                      value={line.accountId}
                      onChange={(id) =>
                        setValue(`lines.${index}.accountId`, id, {
                          shouldValidate: true,
                        })
                      }
                      placeholder="Select account..."
                    />
                  </td>

                  {/* Line Memo */}
                  <td className="p-1.5 border-r border-paper-border">
                    <input
                      type="text"
                      className="w-full px-2 py-1.5 text-xs text-paper-text bg-transparent border border-transparent rounded hover:border-paper-border focus:outline-none focus:bg-white focus:border-brand-navy focus:ring-1 focus:ring-brand-navy/20"
                      placeholder="Optional line memo"
                      {...register(`lines.${index}.description`)}
                    />
                  </td>

                  {/* Debit Input */}
                  <td className="p-1.5 border-r border-paper-border">
                    <input
                      type="text"
                      className={`w-full px-2 py-1.5 text-xs text-right font-mono tabular-nums border rounded focus:outline-none focus:bg-white focus:ring-1 transition-colors ${
                        debitValue
                          ? 'bg-emerald-50/50 border-emerald-300 font-bold text-emerald-900 focus:border-emerald-600 focus:ring-emerald-200'
                          : 'border-paper-border bg-transparent text-paper-text hover:border-paper-border-strong focus:border-brand-navy focus:ring-brand-navy/20'
                      }`}
                      placeholder="0.00"
                      value={debitValue}
                      onChange={(e) =>
                        handleAmountChange(index, 'DEBIT', e.target.value)
                      }
                    />
                  </td>

                  {/* Credit Input */}
                  <td className="p-1.5 border-r border-paper-border">
                    <input
                      type="text"
                      className={`w-full px-2 py-1.5 text-xs text-right font-mono tabular-nums border rounded focus:outline-none focus:bg-white focus:ring-1 transition-colors ${
                        creditValue
                          ? 'bg-blue-50/50 border-blue-300 font-bold text-blue-900 focus:border-blue-600 focus:ring-blue-200'
                          : 'border-paper-border bg-transparent text-paper-text hover:border-paper-border-strong focus:border-brand-navy focus:ring-brand-navy/20'
                      }`}
                      placeholder="0.00"
                      value={creditValue}
                      onChange={(e) =>
                        handleAmountChange(index, 'CREDIT', e.target.value)
                      }
                    />
                  </td>

                  {/* Delete Button */}
                  <td className="text-center p-1.5">
                    <button
                      type="button"
                      onClick={() => fields.length > 2 && remove(index)}
                      disabled={fields.length <= 2}
                      className="p-1 text-paper-subtle hover:text-ledger-red hover:bg-ledger-red-light rounded disabled:opacity-20 disabled:cursor-not-allowed cursor-pointer transition-colors"
                      title={
                        fields.length <= 2
                          ? 'Double-entry requires at least 2 voucher lines'
                          : 'Remove line'
                      }
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                    </button>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      <div className="flex justify-between items-center pt-1">
        <Button
          type="button"
          variant="secondary"
          size="sm"
          onClick={() =>
            append({
              accountId: null,
              side: 'DEBIT',
              amount: '',
              description: '',
            })
          }
          className="cursor-pointer"
        >
          <Plus className="w-3.5 h-3.5 mr-1" />
          <span>Add Voucher Line</span>
        </Button>

        <span className="text-[11px] text-paper-muted italic">
          💡 Double-entry rule: Every voucher must have at least one Debit and one Credit line.
        </span>
      </div>
    </div>
  );
};
