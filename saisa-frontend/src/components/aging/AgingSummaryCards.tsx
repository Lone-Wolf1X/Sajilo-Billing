import React from 'react';
import { formatMoney } from '../../lib/invoiceUtils';
import type { AgingReport } from '../../types/aging';

interface Props {
  report: AgingReport;
  mode: 'AR' | 'AP';
}

export const AgingSummaryCards: React.FC<Props> = ({ report, mode }) => {
  const buckets = [
    {
      label: 'Current (0–30d)',
      value: report.bucket0To30,
      border: 'border-t-paper-border-strong',
      text: 'text-paper-text',
      sub: 'Not overdue',
    },
    {
      label: '31–60 Days',
      value: report.bucket31To60,
      border: 'border-t-amber-400',
      text: 'text-amber-800',
      sub: '1–30d past due',
    },
    {
      label: '61–90 Days',
      value: report.bucket61To90,
      border: 'border-t-orange-500',
      text: 'text-orange-800',
      sub: '31–60d past due',
    },
    {
      label: '90+ Days (Critical)',
      value: report.bucket90Plus,
      border: 'border-t-rose-500',
      text: 'text-rose-800',
      sub: 'Over 60d past due',
    },
  ];

  return (
    <div className="grid grid-cols-2 md:grid-cols-5 gap-3 mb-4">
      {buckets.map((b) => (
        <div
          key={b.label}
          className={`bg-white border border-paper-border border-t-4 ${b.border} rounded-md p-3 shadow-subtle`}
        >
          <div className="text-[10px] font-serif uppercase tracking-wider text-paper-muted">
            {b.label}
          </div>
          <div className={`font-mono text-lg font-bold mt-1 ${b.text}`}>
            {formatMoney(b.value ? String(b.value) : '0')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">{b.sub}</div>
        </div>
      ))}

      <div className="col-span-2 md:col-span-1 bg-[#f5f8fc] border border-[#1e3a5f]/30 border-t-4 border-t-brand-navy rounded-md p-3 shadow-subtle">
        <div className="text-[10px] font-serif uppercase tracking-wider text-brand-navy font-bold">
          Total {mode === 'AR' ? 'Receivables' : 'Payables'}
        </div>
        <div className="font-mono text-lg font-bold text-brand-navy mt-1">
          {formatMoney(report.totalOutstanding ? String(report.totalOutstanding) : '0')}
        </div>
        <div className="text-[10px] text-paper-muted mt-0.5">Total outstanding debt</div>
      </div>
    </div>
  );
};
