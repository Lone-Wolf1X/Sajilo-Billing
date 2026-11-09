import React from 'react';
import { Link } from 'react-router-dom';
import { formatMoney } from '../../lib/invoiceUtils';
import type { PaymentAllocation } from '../../types/payment';
import type { SalesInvoice } from '../../types/salesInvoice';
import type { PurchaseInvoice } from '../../types/purchaseInvoice';

interface Props {
  allocations: PaymentAllocation[];
  invoices: (SalesInvoice | PurchaseInvoice)[];
  invoiceType: 'SALES' | 'PURCHASE';
}

export const PaymentAllocationDisplay: React.FC<Props> = ({
  allocations,
  invoices,
  invoiceType,
}) => {
  if (allocations.length === 0) {
    return (
      <div className="p-3 bg-paper-alt/50 border border-paper-border rounded text-xs text-paper-muted italic">
        No invoice allocations recorded (treated as an unallocated advance on account).
      </div>
    );
  }

  const invoiceMap = new Map(invoices.map((i) => [i.id, i]));

  return (
    <div className="border border-paper-border rounded overflow-hidden">
      <table className="w-full text-xs border-collapse">
        <thead className="bg-paper-alt border-b border-paper-border text-paper-muted">
          <tr>
            <th className="text-left px-3 py-2 font-serif uppercase tracking-wider border-r border-paper-border w-36">
              {invoiceType === 'SALES' ? 'Sales Invoice #' : 'Purchase Bill #'}
            </th>
            <th className="text-left px-3 py-2 font-serif uppercase tracking-wider border-r border-paper-border w-28">
              Date
            </th>
            <th className="text-right px-3 py-2 font-serif uppercase tracking-wider border-r border-paper-border w-32">
              Invoice Total
            </th>
            <th className="text-right px-3 py-2 font-serif uppercase tracking-wider w-36">
              Allocated Amount
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-paper-border">
          {allocations.map((a, i) => {
            const inv = invoiceMap.get(a.invoiceId);
            const path =
              invoiceType === 'SALES'
                ? `/invoices/${a.invoiceId}`
                : `/purchase-invoices/${a.invoiceId}`;

            return (
              <tr key={i} className="hover:bg-paper-warm/20">
                <td className="px-3 py-2 border-r border-paper-border font-mono font-bold text-brand-navy">
                  <Link to={path} className="hover:underline">
                    {inv?.invoiceNumber ?? `#${a.invoiceId}`}
                  </Link>
                </td>
                <td className="px-3 py-2 border-r border-paper-border font-mono text-paper-muted">
                  {inv ? inv.invoiceDate : '—'}
                </td>
                <td className="px-3 py-2 border-r border-paper-border text-right font-mono text-paper-muted">
                  {inv ? formatMoney(inv.totalAmount, '') : '—'}
                </td>
                <td className="px-3 py-2 text-right font-mono font-bold text-paper-text">
                  {formatMoney(a.amount, '')}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};

