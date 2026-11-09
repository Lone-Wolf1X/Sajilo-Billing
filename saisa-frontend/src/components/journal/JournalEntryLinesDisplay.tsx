import React from 'react';
import type { JournalLine } from '../../types/journalEntry';
import type { ChartOfAccount } from '../../types/account';
import { formatMoney } from '@/lib/utils';

interface Props {
  lines: JournalLine[];
  accounts?: ChartOfAccount[];
}

export const JournalEntryLinesDisplay: React.FC<Props> = ({
  lines,
  accounts = [],
}) => {
  let totalDr = 0;
  let totalCr = 0;

  for (const l of lines) {
    totalDr += parseFloat(l.debit || '0');
    totalCr += parseFloat(l.credit || '0');
  }

  const accountMap = React.useMemo(() => {
    const map = new Map<number, ChartOfAccount>();
    for (const a of accounts) {
      map.set(a.id, a);
    }
    return map;
  }, [accounts]);

  return (
    <div className="border border-paper-border rounded-lg overflow-hidden bg-white shadow-subtle">
      <table className="w-full text-xs border-collapse">
        <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
          <tr>
            <th className="w-10 px-2 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border">
              #
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-[35%]">
              Ledger Account
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
              Narration / Line Memo
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-36">
              Debit (₹)
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right w-36">
              Credit (₹)
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-paper-border">
          {lines.map((l, i) => {
            const acc = accountMap.get(l.accountId);
            const drVal = parseFloat(l.debit || '0');
            const crVal = parseFloat(l.credit || '0');

            return (
              <tr key={l.id ?? i} className="hover:bg-paper-hover/30 transition-colors">
                <td className="text-center font-mono text-[11px] text-paper-muted py-2 px-1 border-r border-paper-border bg-paper-alt/20">
                  {l.lineNumber ?? i + 1}
                </td>
                <td className="px-3 py-2 border-r border-paper-border">
                  <div className="flex items-center gap-1.5">
                    <code className="font-mono text-[11px] font-bold text-brand-navy bg-paper-alt px-1 py-0.5 rounded border border-paper-border">
                      {acc?.accountCode ?? l.accountId}
                    </code>
                    <span className="font-medium text-paper-text">
                      {acc?.accountName ?? '—'}
                    </span>
                  </div>
                </td>
                <td className="px-3 py-2 text-paper-muted border-r border-paper-border">
                  {l.description || '—'}
                </td>
                <td className="px-3 py-2 text-right font-mono tabular-nums border-r border-paper-border font-medium text-paper-text">
                  {drVal > 0 ? formatMoney(drVal) : '—'}
                </td>
                <td className="px-3 py-2 text-right font-mono tabular-nums font-medium text-paper-text">
                  {crVal > 0 ? formatMoney(crVal) : '—'}
                </td>
              </tr>
            );
          })}
        </tbody>
        <tfoot className="bg-paper-alt border-t-2 border-paper-border-strong font-bold">
          <tr>
            <td colSpan={3} className="px-3 py-2.5 text-right font-serif uppercase text-xs text-brand-navy">
              Voucher Totals:
            </td>
            <td className="px-3 py-2.5 text-right font-mono tabular-nums border-r border-paper-border text-brand-navy double-underline">
              {formatMoney(totalDr)}
            </td>
            <td className="px-3 py-2.5 text-right font-mono tabular-nums text-brand-navy double-underline">
              {formatMoney(totalCr)}
            </td>
          </tr>
        </tfoot>
      </table>
    </div>
  );
};

