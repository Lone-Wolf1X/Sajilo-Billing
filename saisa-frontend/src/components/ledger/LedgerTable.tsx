import React from 'react';
import type { LedgerEntry, LedgerStatement } from '../../types/ledger';
import { formatMoney } from '@/lib/utils';
import { Link } from 'react-router-dom';

const fmtDate = (d: string) => {
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

const fmtAmt = (v: number | string | null | undefined) => {
  const n = typeof v === 'number' ? v : parseFloat(v ?? '0');
  if (isNaN(n) || n === 0) return '—';
  return formatMoney(n);
};

interface Props {
  statement: LedgerStatement;
  accountName?: string;
  accountCode?: string;
  accountType?: string;
  companyName?: string;
  from: string;
  to: string;
}

export const LedgerTable: React.FC<Props> = ({
  statement,
  accountName,
  accountCode,
  accountType,
  companyName,
  from,
  to,
}) => {
  let totalDr = 0;
  let totalCr = 0;

  for (const e of statement.entries) {
    totalDr += parseFloat(String(e.debit?.amount ?? 0));
    totalCr += parseFloat(String(e.credit?.amount ?? 0));
  }

  const closingBalance =
    statement.entries.length > 0
      ? parseFloat(
          String(
            statement.entries[statement.entries.length - 1].runningBalance?.amount ?? 0
          )
        )
      : 0;

  return (
    <div className="ledger-print-container">
      {/* Print-Only Professional Document Header */}
      <div className="print-only text-center mb-6 pb-4 border-b-2 border-black">
        <h2 className="font-serif text-2xl font-bold uppercase tracking-wider">
          {companyName || 'Enterprise Accounting'}
        </h2>
        <h3 className="font-serif text-lg font-semibold mt-1">
          General Ledger Account Statement
        </h3>
        <p className="text-xs mt-1.5 font-mono">
          Account: <strong>{accountCode} — {accountName}</strong> ({accountType || 'Ledger'})
          <br />
          Statement Period: {fmtDate(from)} to {fmtDate(to)}
        </p>
      </div>

      {/* Screen Header Info Bar */}
      <div className="no-print flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2 mb-4 pb-3 border-b border-paper-border">
        <div>
          <span className="font-mono text-xs font-bold text-brand-navy bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border">
            {accountCode}
          </span>
          <h2 className="font-serif font-bold text-lg text-brand-navy inline-block ml-2">
            {accountName}
          </h2>
        </div>
        <div className="text-xs font-mono text-paper-muted">
          Showing {statement.entries.length} posted transactions
        </div>
      </div>

      {/* Classical Statement Table */}
      <div className="border border-paper-border rounded-lg overflow-hidden bg-white shadow-subtle">
        <table className="data-table w-full text-xs border-collapse">
          <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
            <tr>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-28">
                Date
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-32">
                Voucher Ref
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
                Narration / Transaction Details
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-32">
                Debit (₹)
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-32">
                Credit (₹)
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right w-36">
                Running Balance (₹)
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-paper-border">
            {statement.entries.map((e: LedgerEntry, i: number) => {
              return (
                <tr
                  key={i}
                  className="hover:bg-paper-hover/40 transition-colors"
                >
                  <td className="px-3 py-2 text-xs font-mono border-r border-paper-border">
                    {fmtDate(e.entryDate)}
                  </td>
                  <td className="px-3 py-2 font-mono text-xs border-r border-paper-border">
                    <Link
                      to={`/journal-entries/${e.journalEntryId}`}
                      className="text-brand-navy hover:underline font-semibold"
                    >
                      {e.entryNumber}
                    </Link>
                  </td>
                  <td className="px-3 py-2 text-xs text-paper-text border-r border-paper-border">
                    {e.narration || '—'}
                  </td>
                  <td className="px-3 py-2 text-right font-mono tabular-nums border-r border-paper-border font-medium">
                    {fmtAmt(e.debit?.amount)}
                  </td>
                  <td className="px-3 py-2 text-right font-mono tabular-nums border-r border-paper-border font-medium">
                    {fmtAmt(e.credit?.amount)}
                  </td>
                  <td className="px-3 py-2 text-right font-mono tabular-nums font-bold text-brand-navy bg-paper-alt/20">
                    {fmtAmt(e.runningBalance?.amount)}
                  </td>
                </tr>
              );
            })}
          </tbody>
          <tfoot className="bg-paper-alt border-t-2 border-paper-border-strong font-bold">
            <tr>
              <td colSpan={3} className="px-3 py-2.5 text-right font-serif uppercase text-xs text-brand-navy">
                Period Totals & Closing Balance:
              </td>
              <td className="px-3 py-2.5 text-right font-mono tabular-nums border-r border-paper-border text-brand-navy double-underline">
                {formatMoney(totalDr)}
              </td>
              <td className="px-3 py-2.5 text-right font-mono tabular-nums border-r border-paper-border text-brand-navy double-underline">
                {formatMoney(totalCr)}
              </td>
              <td className="px-3 py-2.5 text-right font-mono tabular-nums text-brand-navy double-underline text-sm font-bold bg-brand-navy-light/40">
                {formatMoney(closingBalance)}
              </td>
            </tr>
          </tfoot>
        </table>
      </div>

      <div className="print-only text-[11px] text-right mt-6 text-black border-t border-black pt-2">
        Statement Generated on {new Date().toLocaleString('en-IN')} · SAISA Accounting Engine
      </div>
    </div>
  );
};

