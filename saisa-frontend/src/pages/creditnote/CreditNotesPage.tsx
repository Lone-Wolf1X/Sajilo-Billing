import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Plus, FileMinus } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { Select } from '../../components/ui/select';
import { Skeleton } from '../../components/ui/skeleton';
import { CustomerCombobox } from '../../components/invoices/CustomerCombobox';
import { useCreditNotes } from '../../hooks/useCreditNotes';
import { useCustomers } from '../../hooks/useCustomers';
import { formatMoney } from '../../lib/invoiceUtils';
import type { CreditNoteListParams, CreditNoteStatus } from '../../types/creditNote';

const fmtDate = (d: string) => {
  if (!d) return '—';
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

export const CreditNotesPage: React.FC = () => {
  const navigate = useNavigate();
  const today = new Date();
  const firstOfMonth = new Date(today.getFullYear(), today.getMonth(), 1)
    .toISOString()
    .slice(0, 10);

  const [filters, setFilters] = useState<CreditNoteListParams>({
    from: firstOfMonth,
    to: today.toISOString().slice(0, 10),
    limit: 100,
  });

  const { data: notes = [], isLoading } = useCreditNotes(filters);
  const { customers = [] } = useCustomers();

  const totalCredited = notes
    .filter((n) => n.status === 'POSTED')
    .reduce((s, n) => s + parseFloat(n.totalAmount || '0'), 0);

  const customerName = (id: number) =>
    customers.find((c) => c.id === id)?.customerName ?? `Customer #${id}`;

  return (
    <div className="p-6 max-w-7xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="font-serif text-2xl font-bold text-brand-navy">
              Credit Notes Register
            </h1>
            <span className="text-xs px-2 py-0.5 rounded bg-brand-burgundy/10 text-brand-burgundy font-serif uppercase tracking-wider font-semibold border border-brand-burgundy/20">
              Sales Returns
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-1">
            Track customer sales returns, adjustments, and Accounts Receivable credits.
          </p>
        </div>

        <Link to="/credit-notes/new">
          <Button className="bg-brand-burgundy hover:bg-brand-burgundy/90 text-white font-serif text-xs px-4 flex items-center gap-1.5 shadow-sm">
            <Plus size={15} />
            <span>New Credit Note</span>
          </Button>
        </Link>
      </div>

      {/* Metrics Ribbon */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm">
          <div className="text-[11px] font-serif uppercase tracking-wider text-paper-muted">
            Total Notes in Range
          </div>
          <div className="font-mono text-2xl font-bold text-brand-navy mt-1">
            {notes.length}
          </div>
          <div className="text-[11px] text-paper-muted mt-0.5">
            {notes.filter((n) => n.status === 'POSTED').length} Posted ·{' '}
            {notes.filter((n) => n.status === 'DRAFT').length} Draft
          </div>
        </div>

        <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm border-l-4 border-l-brand-burgundy">
          <div className="text-[11px] font-serif uppercase tracking-wider text-paper-muted">
            Total Sales Credited
          </div>
          <div className="font-mono text-2xl font-bold text-brand-burgundy mt-1">
            {formatMoney(totalCredited.toFixed(2))}
          </div>
          <div className="text-[11px] text-paper-muted mt-0.5">
            Offset against customer balances & output VAT
          </div>
        </div>

        <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm">
          <div className="text-[11px] font-serif uppercase tracking-wider text-paper-muted">
            Avg Credit Value
          </div>
          <div className="font-mono text-2xl font-bold text-brand-navy mt-1">
            {notes.length > 0
              ? formatMoney((totalCredited / notes.length).toFixed(2))
              : 'NPR 0.00'}
          </div>
          <div className="text-[11px] text-paper-muted mt-0.5">
            Per posted return voucher
          </div>
        </div>
      </div>

      {/* Filters Card */}
      <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
          <div>
            <Label className="text-xs font-serif text-brand-navy">From Date</Label>
            <Input
              type="date"
              className="font-mono text-xs h-9"
              value={filters.from ?? ''}
              onChange={(e) => setFilters({ ...filters, from: e.target.value })}
            />
          </div>

          <div>
            <Label className="text-xs font-serif text-brand-navy">To Date</Label>
            <Input
              type="date"
              className="font-mono text-xs h-9"
              value={filters.to ?? ''}
              onChange={(e) => setFilters({ ...filters, to: e.target.value })}
            />
          </div>

          <div>
            <Label className="text-xs font-serif text-brand-navy">Customer</Label>
            <CustomerCombobox
              value={filters.customerId ?? null}
              onChange={(id) => setFilters({ ...filters, customerId: id ?? undefined })}
            />
          </div>

          <div>
            <Label className="text-xs font-serif text-brand-navy">Status</Label>
            <Select
              className="text-xs h-9"
              value={filters.status ?? ''}
              onChange={(e) =>
                setFilters({
                  ...filters,
                  status: (e.target.value || undefined) as CreditNoteStatus,
                })
              }
            >
              <option value="">All Statuses</option>
              <option value="POSTED">Posted</option>
              <option value="DRAFT">Draft</option>
              <option value="CANCELLED">Cancelled</option>
            </Select>
          </div>
        </div>
      </div>

      {/* Table Card */}
      <div className="bg-white border border-paper-border rounded-lg overflow-hidden shadow-sm">
        {isLoading ? (
          <div className="p-6 space-y-3">
            {[1, 2, 3, 4, 5].map((i) => (
              <Skeleton key={i} className="h-10 w-full" />
            ))}
          </div>
        ) : notes.length === 0 ? (
          <div className="p-12 text-center space-y-3">
            <FileMinus size={44} className="mx-auto text-paper-muted" />
            <h3 className="font-serif text-base font-semibold text-brand-navy">
              No credit notes found
            </h3>
            <p className="text-xs text-paper-muted max-w-sm mx-auto">
              There are no sales return notes matching the current filters. Create your first credit note to adjust customer invoices.
            </p>
            <Link to="/credit-notes/new">
              <Button
                variant="outline"
                size="sm"
                className="mt-2 border-paper-border text-brand-navy hover:bg-paper-alt font-serif text-xs"
              >
                <Plus size={14} className="mr-1" /> Create Credit Note
              </Button>
            </Link>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm border-collapse">
              <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-brand-navy">
                <tr>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    CN #
                  </th>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Date
                  </th>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Customer
                  </th>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Reason / Notes
                  </th>
                  <th className="px-4 py-3 text-right font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Total Credit
                  </th>
                  <th className="px-4 py-3 text-center font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Status
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-paper-border">
                {notes.map((n) => (
                  <tr
                    key={n.id}
                    onClick={() => navigate(`/credit-notes/${n.id}`)}
                    className="hover:bg-paper-alt/50 cursor-pointer transition-colors"
                  >
                    <td className="px-4 py-3 font-mono text-xs font-semibold text-brand-navy">
                      {n.creditNoteNumber}
                    </td>
                    <td className="px-4 py-3 font-mono text-xs text-paper-muted">
                      {fmtDate(n.creditNoteDate)}
                    </td>
                    <td className="px-4 py-3 font-serif text-xs font-medium text-brand-navy">
                      {customerName(n.customerId)}
                    </td>
                    <td className="px-4 py-3 text-xs text-paper-muted truncate max-w-xs">
                      {n.reason || <span className="text-paper-muted/50">—</span>}
                    </td>
                    <td className="px-4 py-3 text-right font-mono tabular-nums text-xs font-bold text-brand-burgundy">
                      {formatMoney(n.totalAmount)}
                    </td>
                    <td className="px-4 py-3 text-center">
                      <span
                        className={`inline-block text-[10px] font-serif uppercase tracking-wider font-semibold px-2 py-0.5 rounded border ${
                          n.status === 'POSTED'
                            ? 'bg-emerald-50 text-emerald-800 border-emerald-200'
                            : n.status === 'DRAFT'
                            ? 'bg-amber-50 text-amber-800 border-amber-200'
                            : 'bg-gray-100 text-gray-700 border-gray-300'
                        }`}
                      >
                        {n.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};
