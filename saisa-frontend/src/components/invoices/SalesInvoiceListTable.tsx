import React from 'react';
import { Eye, Printer } from 'lucide-react';
import { Button } from '../ui/button';
import { Skeleton } from '../ui/skeleton';
import { InvoiceStatusBadge, PaymentStatusBadge } from './InvoiceStatusBadge';
import { formatMoney, getPaymentStatus } from '../../lib/invoiceUtils';
import type { SalesInvoice } from '../../types/salesInvoice';
import type { Customer } from '../../types/customer';

interface Props {
  invoices: SalesInvoice[];
  customers: Customer[];
  isLoading: boolean;
  onView: (id: number) => void;
  onPrint?: (invoice: SalesInvoice) => void;
  onCreateNew?: () => void;
}

export const SalesInvoiceListTable: React.FC<Props> = ({
  invoices,
  customers,
  isLoading,
  onView,
  onPrint,
  onCreateNew,
}) => {
  const customerMap = React.useMemo(() => {
    const map = new Map<number, Customer>();
    for (const c of customers) {
      map.set(c.id, c);
    }
    return map;
  }, [customers]);

  if (isLoading) {
    return (
      <div className="bg-white border border-paper-border rounded-md p-4 space-y-3">
        <Skeleton className="h-8 w-full" />
        <Skeleton className="h-10 w-full" />
        <Skeleton className="h-10 w-full" />
        <Skeleton className="h-10 w-full" />
      </div>
    );
  }

  if (invoices.length === 0) {
    return (
      <div className="bg-white border border-paper-border rounded-md p-10 text-center space-y-3 shadow-subtle">
        <div className="mx-auto w-12 h-12 rounded-full bg-paper-alt flex items-center justify-center text-paper-muted border border-paper-border">
          📄
        </div>
        <h3 className="font-serif text-base font-bold text-brand-navy">
          No Sales Invoices Found
        </h3>
        <p className="text-xs text-paper-muted max-w-sm mx-auto">
          No invoices match the selected date or customer filters. Create your first sales invoice to begin billing.
        </p>
        {onCreateNew && (
          <Button
            onClick={onCreateNew}
            size="sm"
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif mt-2"
          >
            + Create New Invoice [F8]
          </Button>
        )}
      </div>
    );
  }

  return (
    <div className="bg-white border border-paper-border rounded-md overflow-hidden shadow-subtle">
      <div className="overflow-x-auto">
        <table className="w-full text-xs border-collapse min-w-[850px]">
          <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
            <tr>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-32">
                Invoice #
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-24">
                Date
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
                Customer
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-24">
                Due Date
              </th>
              <th className="px-2.5 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border w-24">
                Status
              </th>
              <th className="px-2.5 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border w-24">
                Payment
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
                Total (NPR)
              </th>
              <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
                Outstanding
              </th>
              <th className="px-2.5 py-2.5 font-serif uppercase tracking-wider text-center w-24">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-paper-border">
            {invoices.map((inv) => {
              const cust = customerMap.get(inv.customerId);
              const custName = inv.customerName || cust?.customerName || `Customer #${inv.customerId}`;
              const pStatus = getPaymentStatus(inv);

              return (
                <tr
                  key={inv.id}
                  className="hover:bg-paper-warm/30 transition-colors cursor-pointer group"
                  onClick={() => onView(inv.id)}
                >
                  {/* Invoice Number */}
                  <td className="px-3 py-2.5 font-mono font-bold text-brand-navy border-r border-paper-border">
                    <span className="underline decoration-dotted group-hover:decoration-solid">
                      {inv.invoiceNumber}
                    </span>
                  </td>

                  {/* Date */}
                  <td className="px-3 py-2.5 font-mono text-paper-muted border-r border-paper-border">
                    {inv.invoiceDate}
                  </td>

                  {/* Customer */}
                  <td className="px-3 py-2.5 border-r border-paper-border">
                    <div className="font-medium text-paper-text">{custName}</div>
                    {cust?.customerCode && (
                      <span className="font-mono text-[10px] text-paper-muted">
                        {cust.customerCode}
                      </span>
                    )}
                  </td>

                  {/* Due Date */}
                  <td className="px-3 py-2.5 font-mono text-paper-muted border-r border-paper-border">
                    {inv.dueDate || '—'}
                  </td>

                  {/* Status */}
                  <td className="px-2.5 py-2 text-center border-r border-paper-border">
                    <InvoiceStatusBadge status={inv.status} />
                  </td>

                  {/* Payment Status */}
                  <td className="px-2.5 py-2 text-center border-r border-paper-border">
                    <PaymentStatusBadge status={pStatus} />
                  </td>

                  {/* Total Amount */}
                  <td className="px-3 py-2.5 text-right font-mono font-medium text-paper-text border-r border-paper-border">
                    {formatMoney(inv.totalAmount, '')}
                  </td>

                  {/* Outstanding */}
                  <td className="px-3 py-2.5 text-right font-mono font-bold border-r border-paper-border">
                    <span
                      className={
                        Number(inv.amountOutstanding) > 0
                          ? 'text-[#7a2e2e]'
                          : 'text-paper-muted'
                      }
                    >
                      {formatMoney(inv.amountOutstanding, '')}
                    </span>
                  </td>

                  {/* Actions */}
                  <td
                    className="px-2 py-2 text-center"
                    onClick={(e) => e.stopPropagation()}
                  >
                    <div className="flex items-center justify-center gap-1">
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => onView(inv.id)}
                        className="h-7 w-7 p-0 text-paper-muted hover:text-brand-navy"
                        title="View Invoice"
                      >
                        <Eye className="h-3.5 w-3.5" />
                      </Button>
                      {onPrint && (
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => onPrint(inv)}
                          className="h-7 w-7 p-0 text-paper-muted hover:text-brand-navy"
                          title="Print Invoice"
                        >
                          <Printer className="h-3.5 w-3.5" />
                        </Button>
                      )}
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Footer bar with invoice count */}
      <div className="bg-paper-alt px-4 py-2 border-t border-paper-border flex items-center justify-between text-xs text-paper-muted">
        <span>Showing {invoices.length} invoice(s)</span>
        <span className="font-serif italic text-[11px]">
          Click any row to open full invoice voucher
        </span>
      </div>
    </div>
  );
};

