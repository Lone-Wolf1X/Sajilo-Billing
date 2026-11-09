import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { ChevronRight, ChevronDown } from 'lucide-react';
import { fmtAgingAmount } from '../../lib/agingUtils';
import { formatMoney } from '../../lib/invoiceUtils';
import type { CustomerAgingGroup } from '../../lib/agingUtils';

interface Props {
  groups: CustomerAgingGroup[];
  mode: 'AR' | 'AP';
}

function daysToBucket(days: number): 'CURRENT' | '1-30' | '31-60' | '61-90' | '90+' {
  if (days <= 0) return 'CURRENT';
  if (days <= 30) return '1-30';
  if (days <= 60) return '31-60';
  if (days <= 90) return '61-90';
  return '90+';
}

function bucketBgClass(bucket: 'CURRENT' | '1-30' | '31-60' | '61-90' | '90+'): string {
  switch (bucket) {
    case '1-30':
      return 'bg-amber-50 text-amber-900 font-semibold';
    case '31-60':
      return 'bg-amber-100 text-amber-950 font-bold';
    case '61-90':
      return 'bg-orange-100 text-orange-950 font-bold';
    case '90+':
      return 'bg-rose-100 text-rose-950 font-bold';
    default:
      return 'text-paper-text font-medium';
  }
}

export const AgingMatrixTable: React.FC<Props> = ({ groups, mode }) => {
  const [expanded, setExpanded] = useState<Set<number>>(new Set());

  const toggle = (id: number) => {
    setExpanded((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const partyLabel = mode === 'AR' ? 'Customer' : 'Vendor';

  const totals = groups.reduce(
    (acc, g) => ({
      current: acc.current + g.bucketCurrent,
      b1: acc.b1 + g.bucket1To30,
      b31: acc.b31 + g.bucket31To60,
      b61: acc.b61 + g.bucket61To90,
      b90: acc.b90 + g.bucket90Plus,
      total: acc.total + g.total,
    }),
    { current: 0, b1: 0, b31: 0, b61: 0, b90: 0, total: 0 }
  );

  return (
    <div className="overflow-x-auto">
      <table className="w-full text-xs border-collapse min-w-[850px]">
        <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
          <tr>
            <th className="w-8 px-2 py-2.5 text-center border-r border-paper-border"></th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
              {partyLabel} / Entity
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
              Current
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
              1–30d
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
              31–60d
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
              61–90d
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
              90+d
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right w-32 font-bold">
              Total Due (NPR)
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-paper-border">
          {groups.map((group) => {
            const isExpanded = expanded.has(group.partyId);

            return (
              <React.Fragment key={group.partyId}>
                {/* Main Party Row */}
                <tr
                  onClick={() => toggle(group.partyId)}
                  className={`hover:bg-paper-warm/40 transition-colors cursor-pointer select-none ${
                    isExpanded ? 'bg-paper-warm/20 font-semibold' : ''
                  }`}
                >
                  <td className="px-2 py-2 text-center text-paper-muted border-r border-paper-border">
                    {isExpanded ? (
                      <ChevronDown className="h-3.5 w-3.5 mx-auto text-brand-navy" />
                    ) : (
                      <ChevronRight className="h-3.5 w-3.5 mx-auto text-paper-muted" />
                    )}
                  </td>
                  <td className="px-3 py-2 border-r border-paper-border">
                    <div className="font-serif font-bold text-paper-text text-xs flex items-center gap-1.5">
                      <span>{group.partyName}</span>
                      <span className="text-[10px] text-paper-muted font-mono font-normal">
                        ({group.invoices.length} bill{group.invoices.length > 1 ? 's' : ''})
                      </span>
                    </div>
                    {group.partyCode && (
                      <span className="text-[10px] text-paper-muted font-mono">
                        {group.partyCode}
                      </span>
                    )}
                  </td>
                  <td className="px-3 py-2 text-right font-mono text-paper-text border-r border-paper-border">
                    {fmtAgingAmount(group.bucketCurrent)}
                  </td>
                  <td className="px-3 py-2 text-right font-mono text-amber-900 border-r border-paper-border">
                    {fmtAgingAmount(group.bucket1To30)}
                  </td>
                  <td className="px-3 py-2 text-right font-mono text-amber-950 font-semibold border-r border-paper-border">
                    {fmtAgingAmount(group.bucket31To60)}
                  </td>
                  <td className="px-3 py-2 text-right font-mono text-orange-950 font-bold border-r border-paper-border">
                    {fmtAgingAmount(group.bucket61To90)}
                  </td>
                  <td className="px-3 py-2 text-right font-mono text-rose-950 font-bold border-r border-paper-border">
                    {fmtAgingAmount(group.bucket90Plus)}
                  </td>
                  <td className="px-3 py-2 text-right font-mono font-bold text-brand-navy">
                    {formatMoney(group.total.toFixed(2), '')}
                  </td>
                </tr>

                {/* Sub-Rows (Individual Invoices) */}
                {isExpanded &&
                  group.invoices.map((inv) => {
                    const days = inv.daysOverdue ?? 0;
                    const bucket = daysToBucket(days);
                    const invPath =
                      mode === 'AR'
                        ? `/invoices/${inv.invoiceId}`
                        : `/purchase-invoices/${inv.invoiceId}`;

                    return (
                      <tr
                        key={`${group.partyId}-${inv.invoiceId}`}
                        className="bg-paper-alt/60 text-xs border-b border-paper-border/60 hover:bg-paper-warm/30"
                      >
                        <td className="border-r border-paper-border"></td>
                        <td className="pl-6 pr-3 py-1.5 border-r border-paper-border">
                          <div className="flex items-center gap-2">
                            <Link
                              to={invPath}
                              className="font-mono font-bold text-brand-navy hover:underline"
                            >
                              {inv.invoiceNumber}
                            </Link>
                            <span className="text-[10px] text-paper-muted font-mono">
                              Dated: {inv.invoiceDate}
                            </span>
                          </div>
                          <div className="text-[10px] text-paper-muted flex items-center gap-2 mt-0.5">
                            <span>Due: {inv.dueDate || 'On Receipt'}</span>
                            {days > 0 && (
                              <span className="text-[#7a2e2e] font-semibold">
                                • {days} days overdue
                              </span>
                            )}
                          </div>
                        </td>

                        {/* Current Column */}
                        <td
                          className={`px-3 py-1.5 text-right font-mono border-r border-paper-border ${
                            bucket === 'CURRENT' ? bucketBgClass('CURRENT') : 'text-paper-muted'
                          }`}
                        >
                          {bucket === 'CURRENT' ? formatMoney(String(inv.outstanding), '') : '—'}
                        </td>

                        {/* 1-30 Column */}
                        <td
                          className={`px-3 py-1.5 text-right font-mono border-r border-paper-border ${
                            bucket === '1-30' ? bucketBgClass('1-30') : 'text-paper-muted'
                          }`}
                        >
                          {bucket === '1-30' ? formatMoney(String(inv.outstanding), '') : '—'}
                        </td>

                        {/* 31-60 Column */}
                        <td
                          className={`px-3 py-1.5 text-right font-mono border-r border-paper-border ${
                            bucket === '31-60' ? bucketBgClass('31-60') : 'text-paper-muted'
                          }`}
                        >
                          {bucket === '31-60' ? formatMoney(String(inv.outstanding), '') : '—'}
                        </td>

                        {/* 61-90 Column */}
                        <td
                          className={`px-3 py-1.5 text-right font-mono border-r border-paper-border ${
                            bucket === '61-90' ? bucketBgClass('61-90') : 'text-paper-muted'
                          }`}
                        >
                          {bucket === '61-90' ? formatMoney(String(inv.outstanding), '') : '—'}
                        </td>

                        {/* 90+ Column */}
                        <td
                          className={`px-3 py-1.5 text-right font-mono border-r border-paper-border ${
                            bucket === '90+' ? bucketBgClass('90+') : 'text-paper-muted'
                          }`}
                        >
                          {bucket === '90+' ? formatMoney(String(inv.outstanding), '') : '—'}
                        </td>

                        {/* Invoice Total Outstanding */}
                        <td className="px-3 py-1.5 text-right font-mono font-bold text-paper-text">
                          {formatMoney(String(inv.outstanding), '')}
                        </td>
                      </tr>
                    );
                  })}
              </React.Fragment>
            );
          })}
        </tbody>

        {/* Grand Total Footer with classical double underline */}
        <tfoot className="bg-paper-alt font-bold border-t-2 border-paper-border-strong text-xs">
          <tr>
            <td className="border-r border-paper-border"></td>
            <td className="px-3 py-2.5 font-serif uppercase tracking-wider text-paper-text border-r border-paper-border">
              Grand Total ({groups.length} {partyLabel.toLowerCase()}{groups.length > 1 ? 's' : ''})
            </td>
            <td className="px-3 py-2.5 text-right font-mono text-paper-text border-r border-paper-border">
              {fmtAgingAmount(totals.current)}
            </td>
            <td className="px-3 py-2.5 text-right font-mono text-amber-900 border-r border-paper-border">
              {fmtAgingAmount(totals.b1)}
            </td>
            <td className="px-3 py-2.5 text-right font-mono text-amber-950 border-r border-paper-border">
              {fmtAgingAmount(totals.b31)}
            </td>
            <td className="px-3 py-2.5 text-right font-mono text-orange-950 border-r border-paper-border">
              {fmtAgingAmount(totals.b61)}
            </td>
            <td className="px-3 py-2.5 text-right font-mono text-rose-950 border-r border-paper-border">
              {fmtAgingAmount(totals.b90)}
            </td>
            <td className="px-3 py-2.5 text-right font-mono font-bold text-brand-navy underline decoration-double decoration-brand-navy underline-offset-4">
              {formatMoney(totals.total.toFixed(2), '')}
            </td>
          </tr>
        </tfoot>
      </table>
    </div>
  );
};
