import React from 'react';
import { Button } from '../ui/button';
import { Input } from '../ui/input';
import { formatMoney } from '../../lib/invoiceUtils';
import { Zap } from 'lucide-react';

export interface UnpaidInvoice {
  id: number;
  invoiceNumber: string;
  invoiceDate: string;
  dueDate?: string | null;
  totalAmount: number | string;
  amountPaid: number | string;
  amountOutstanding?: number | string;
}

export interface Allocation {
  invoiceId: number;
  amount: string;
}

interface Props {
  invoices: UnpaidInvoice[];
  allocations: Allocation[];
  paymentAmount: string;
  onAllocationsChange: (allocations: Allocation[]) => void;
}

export const InvoiceAllocationTable: React.FC<Props> = ({
  invoices,
  allocations,
  paymentAmount,
  onAllocationsChange,
}) => {
  const allocatedMap = React.useMemo(() => {
    return new Map(allocations.map((a) => [a.invoiceId, a.amount]));
  }, [allocations]);

  const totalAllocated = React.useMemo(() => {
    return allocations.reduce(
      (sum, a) => sum + (parseFloat(a.amount) || 0),
      0
    );
  }, [allocations]);

  const totalPayment = parseFloat(paymentAmount) || 0;
  const unallocated = Math.round((totalPayment - totalAllocated) * 100) / 100;

  const getOutstanding = (inv: UnpaidInvoice) => {
    if (inv.amountOutstanding !== undefined && inv.amountOutstanding !== null) {
      return Number(inv.amountOutstanding);
    }
    const tot = parseFloat(String(inv.totalAmount)) || 0;
    const paid = parseFloat(String(inv.amountPaid)) || 0;
    return Math.max(0, tot - paid);
  };

  const handleAmountChange = (invoiceId: number, raw: string) => {
    const cleaned = raw.replace(/,/g, '').trim();
    if (cleaned !== '' && !/^\d*(\.\d{0,4})?$/.test(cleaned)) return;

    const next = allocations.filter((a) => a.invoiceId !== invoiceId);
    if (cleaned !== '' && parseFloat(cleaned) > 0) {
      next.push({ invoiceId, amount: cleaned });
    }
    onAllocationsChange(next);
  };

  const toggleInvoice = (inv: UnpaidInvoice) => {
    const isAllocated = allocatedMap.has(inv.id);
    if (isAllocated) {
      onAllocationsChange(allocations.filter((a) => a.invoiceId !== inv.id));
    } else {
      const outstanding = getOutstanding(inv);
      const remainingToAllocate = Math.max(0, totalPayment - totalAllocated);
      const amountToAssign = remainingToAllocate > 0
        ? Math.min(outstanding, remainingToAllocate)
        : outstanding;

      const next = allocations.filter((a) => a.invoiceId !== inv.id);
      next.push({ invoiceId: inv.id, amount: amountToAssign.toFixed(2) });
      onAllocationsChange(next);
    }
  };

  const autoAllocateFIFO = () => {
    let remaining = totalPayment;
    const next: Allocation[] = [];
    // Sort oldest invoices first
    const sorted = [...invoices].sort((a, b) =>
      a.invoiceDate.localeCompare(b.invoiceDate)
    );

    for (const inv of sorted) {
      if (remaining <= 0) break;
      const outstanding = getOutstanding(inv);
      if (outstanding <= 0) continue;

      const toAlloc = Math.min(outstanding, remaining);
      next.push({ invoiceId: inv.id, amount: toAlloc.toFixed(2) });
      remaining -= toAlloc;
    }

    onAllocationsChange(next);
  };

  if (invoices.length === 0) {
    return (
      <div className="bg-paper-alt/50 border border-paper-border rounded-md p-6 text-center text-xs text-paper-muted italic">
        No pending or unpaid vouchers found for this party. Any payment entered will be credited as an Advance Payment on Account.
      </div>
    );
  }

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <span className="text-xs text-paper-muted">
          Select vouchers below to settle, or click Auto-allocate to clear oldest first.
        </span>

        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={autoAllocateFIFO}
          disabled={totalPayment <= 0}
          className="h-7 text-xs border-paper-border text-brand-navy hover:bg-paper-alt flex items-center gap-1"
        >
          <Zap className="h-3 w-3 text-amber-600" />
          <span>Auto-allocate (FIFO)</span>
        </Button>
      </div>

      <div className="border border-paper-border rounded-md overflow-hidden bg-white shadow-subtle">
        <div className="overflow-x-auto">
          <table className="w-full text-xs border-collapse min-w-[700px]">
            <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
              <tr>
                <th className="w-10 px-2 py-2 text-center border-r border-paper-border">
                  <span className="sr-only">Select</span>
                </th>
                <th className="px-3 py-2 font-serif uppercase tracking-wider text-left border-r border-paper-border w-32">
                  Invoice / Bill #
                </th>
                <th className="px-3 py-2 font-serif uppercase tracking-wider text-left border-r border-paper-border w-24">
                  Date
                </th>
                <th className="px-3 py-2 font-serif uppercase tracking-wider text-left border-r border-paper-border w-24">
                  Due Date
                </th>
                <th className="px-3 py-2 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
                  Total (NPR)
                </th>
                <th className="px-3 py-2 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
                  Outstanding
                </th>
                <th className="px-3 py-2 font-serif uppercase tracking-wider text-right w-36">
                  Allocate (NPR)
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-paper-border">
              {invoices.map((inv) => {
                const outstanding = getOutstanding(inv);
                const isChecked = allocatedMap.has(inv.id);
                const allocVal = allocatedMap.get(inv.id) || '';

                return (
                  <tr
                    key={inv.id}
                    className={`hover:bg-paper-warm/30 transition-colors ${
                      isChecked ? 'bg-[#f5f8fc]' : ''
                    }`}
                  >
                    {/* Checkbox */}
                    <td className="px-2 py-2 text-center border-r border-paper-border">
                      <input
                        type="checkbox"
                        checked={isChecked}
                        onChange={() => toggleInvoice(inv)}
                        className="rounded border-paper-border text-brand-navy focus:ring-brand-navy cursor-pointer"
                      />
                    </td>

                    {/* Number */}
                    <td className="px-3 py-2 font-mono font-bold text-brand-navy border-r border-paper-border">
                      {inv.invoiceNumber}
                    </td>

                    {/* Date */}
                    <td className="px-3 py-2 font-mono text-paper-muted border-r border-paper-border">
                      {inv.invoiceDate}
                    </td>

                    {/* Due */}
                    <td className="px-3 py-2 font-mono text-paper-muted border-r border-paper-border">
                      {inv.dueDate || '—'}
                    </td>

                    {/* Total */}
                    <td className="px-3 py-2 text-right font-mono text-paper-text border-r border-paper-border">
                      {formatMoney(inv.totalAmount, '')}
                    </td>

                    {/* Outstanding */}
                    <td className="px-3 py-2 text-right font-mono font-bold text-[#7a2e2e] border-r border-paper-border">
                      {formatMoney(outstanding, '')}
                    </td>

                    {/* Allocation Input */}
                    <td className="px-2 py-1.5 text-right">
                      <Input
                        value={allocVal}
                        onChange={(e) =>
                          handleAmountChange(inv.id, e.target.value)
                        }
                        placeholder="0.00"
                        className="h-8 text-xs text-right font-mono font-bold bg-white"
                      />
                    </td>
                  </tr>
                );
              })}
            </tbody>
            <tfoot className="bg-paper-alt border-t-2 border-paper-border-strong font-medium text-xs">
              <tr>
                <td
                  colSpan={6}
                  className="px-3 py-2 text-right font-serif uppercase tracking-wider text-paper-muted"
                >
                  Total Allocated to Invoices:
                </td>
                <td className="px-3 py-2 text-right font-mono font-bold text-brand-navy">
                  {formatMoney(totalAllocated.toFixed(2))}
                </td>
              </tr>
              <tr>
                <td
                  colSpan={6}
                  className="px-3 py-2 text-right font-serif uppercase tracking-wider text-paper-muted"
                >
                  Unallocated (Advance on Account):
                </td>
                <td
                  className={`px-3 py-2 text-right font-mono font-bold ${
                    unallocated < -0.001
                      ? 'text-red-700'
                      : unallocated > 0.001
                      ? 'text-amber-700'
                      : 'text-[#2d6a4f]'
                  }`}
                >
                  {formatMoney(unallocated.toFixed(2))}
                </td>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>
    </div>
  );
};

