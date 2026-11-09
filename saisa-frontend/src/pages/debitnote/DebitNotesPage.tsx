import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Plus, FileMinus } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { Select } from '../../components/ui/select';
import { Skeleton } from '../../components/ui/skeleton';
import { VendorCombobox } from '../../components/invoices/VendorCombobox';
import { useDebitNotes } from '../../hooks/useDebitNotes';
import { useVendors } from '../../hooks/useVendors';
import { formatMoney } from '../../lib/invoiceUtils';
import type { DebitNoteListParams, DebitNoteStatus } from '../../types/debitNote';

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

export const DebitNotesPage: React.FC = () => {
  const navigate = useNavigate();
  const today = new Date();
  const firstOfMonth = new Date(today.getFullYear(), today.getMonth(), 1)
    .toISOString()
    .slice(0, 10);

  const [filters, setFilters] = useState<DebitNoteListParams>({
    from: firstOfMonth,
    to: today.toISOString().slice(0, 10),
    limit: 100,
  });

  const { data: notes = [], isLoading } = useDebitNotes(filters);
  const { vendors = [] } = useVendors();

  const totalDebited = notes
    .filter((n) => n.status === 'POSTED')
    .reduce((s, n) => s + parseFloat(n.totalAmount || '0'), 0);

  const vendorName = (id: number) =>
    vendors.find((v) => v.id === id)?.vendorName ?? `Vendor #${id}`;

  return (
    <div className="p-6 max-w-7xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="font-serif text-2xl font-bold text-brand-navy">
              Debit Notes Register
            </h1>
            <span className="text-xs px-2 py-0.5 rounded bg-amber-500/10 text-amber-800 font-serif uppercase tracking-wider font-semibold border border-amber-500/20">
              Purchase Returns
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-1">
            Track vendor purchase returns, allowances, and Accounts Payable debits.
          </p>
        </div>

        <Link to="/debit-notes/new">
          <Button className="bg-emerald-700 hover:bg-emerald-800 text-white font-serif text-xs px-4 flex items-center gap-1.5 shadow-sm">
            <Plus size={15} />
            <span>New Debit Note</span>
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

        <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm border-l-4 border-l-emerald-600">
          <div className="text-[11px] font-serif uppercase tracking-wider text-paper-muted">
            Total Purchase Debited
          </div>
          <div className="font-mono text-2xl font-bold text-emerald-700 mt-1">
            {formatMoney(totalDebited.toFixed(2))}
          </div>
          <div className="text-[11px] text-paper-muted mt-0.5">
            Reduced from vendor liabilities & input VAT
          </div>
        </div>

        <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm">
          <div className="text-[11px] font-serif uppercase tracking-wider text-paper-muted">
            Avg Debit Value
          </div>
          <div className="font-mono text-2xl font-bold text-brand-navy mt-1">
            {notes.length > 0
              ? formatMoney((totalDebited / notes.length).toFixed(2))
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
            <Label className="text-xs font-serif text-brand-navy">Vendor / Supplier</Label>
            <VendorCombobox
              value={filters.vendorId ?? null}
              onChange={(id) => setFilters({ ...filters, vendorId: id ?? undefined })}
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
                  status: (e.target.value || undefined) as DebitNoteStatus,
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
              No debit notes found
            </h3>
            <p className="text-xs text-paper-muted max-w-sm mx-auto">
              There are no purchase return notes matching the current filters. Create your first debit note to adjust vendor bills.
            </p>
            <Link to="/debit-notes/new">
              <Button
                variant="outline"
                size="sm"
                className="mt-2 border-paper-border text-brand-navy hover:bg-paper-alt font-serif text-xs"
              >
                <Plus size={14} className="mr-1" /> Create Debit Note
              </Button>
            </Link>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm border-collapse">
              <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-brand-navy">
                <tr>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    DN #
                  </th>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Date
                  </th>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Vendor
                  </th>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Reason / Notes
                  </th>
                  <th className="px-4 py-3 text-right font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Total Debit
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
                    onClick={() => navigate(`/debit-notes/${n.id}`)}
                    className="hover:bg-paper-alt/50 cursor-pointer transition-colors"
                  >
                    <td className="px-4 py-3 font-mono text-xs font-semibold text-brand-navy">
                      {n.debitNoteNumber}
                    </td>
                    <td className="px-4 py-3 font-mono text-xs text-paper-muted">
                      {fmtDate(n.debitNoteDate)}
                    </td>
                    <td className="px-4 py-3 font-serif text-xs font-medium text-brand-navy">
                      {vendorName(n.vendorId)}
                    </td>
                    <td className="px-4 py-3 text-xs text-paper-muted truncate max-w-xs">
                      {n.reason || <span className="text-paper-muted/50">—</span>}
                    </td>
                    <td className="px-4 py-3 text-right font-mono tabular-nums text-xs font-bold text-emerald-700">
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
