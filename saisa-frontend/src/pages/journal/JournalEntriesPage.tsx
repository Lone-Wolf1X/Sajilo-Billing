import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { Plus, FileText, RotateCcw } from 'lucide-react';
import { JournalEntryListTable } from '../../components/journal/JournalEntryListTable';
import { Skeleton } from '../../components/ui/skeleton';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { Select } from '../../components/ui/select';
import { useJournalEntryList } from '../../hooks/useJournalEntries';
import type { EntryStatus, JournalEntryListParams } from '../../types/journalEntry';

export const JournalEntriesPage: React.FC = () => {
  const today = new Date();
  const firstOfMonth = new Date(today.getFullYear(), today.getMonth(), 1)
    .toISOString()
    .slice(0, 10);

  const [filters, setFilters] = useState<JournalEntryListParams>({
    from: firstOfMonth,
    to: today.toISOString().slice(0, 10),
    status: undefined,
    limit: 50,
  });

  const { data: entries = [], isLoading, error } = useJournalEntryList(filters);

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 pb-4 border-b border-paper-border">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="font-serif text-2xl font-bold text-brand-navy">
              Journal Entries & Vouchers
            </h1>
            <span className="text-xs font-mono font-semibold bg-paper-alt px-2 py-0.5 rounded border border-paper-border text-paper-muted">
              {entries.length} Entries in Filter
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-1">
            Chronological audit log of all financial vouchers (Drafts, Posted, and Reversals).
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Link to="/journal-entries/new">
            <Button variant="primary" size="md">
              <Plus className="w-4 h-4 mr-1" />
              <span>New Voucher [F7]</span>
            </Button>
          </Link>
        </div>
      </div>

      {/* Filter Bar */}
      <div className="bg-paper-surface border border-paper-border rounded-lg p-4 shadow-subtle">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 items-end">
          <div>
            <Label htmlFor="from">From Date</Label>
            <Input
              id="from"
              type="date"
              value={filters.from ?? ''}
              onChange={(e) =>
                setFilters((prev) => ({ ...prev, from: e.target.value }))
              }
            />
          </div>

          <div>
            <Label htmlFor="to">To Date</Label>
            <Input
              id="to"
              type="date"
              value={filters.to ?? ''}
              onChange={(e) =>
                setFilters((prev) => ({ ...prev, to: e.target.value }))
              }
            />
          </div>

          <div>
            <Label htmlFor="status">Voucher Status</Label>
            <Select
              id="status"
              value={filters.status ?? ''}
              onChange={(e) =>
                setFilters((prev) => ({
                  ...prev,
                  status: (e.target.value || undefined) as EntryStatus | undefined,
                }))
              }
            >
              <option value="">All Statuses (Draft, Posted, Reversed)</option>
              <option value="POSTED">POSTED (General Ledger)</option>
              <option value="DRAFT">DRAFT (Unposted)</option>
              <option value="REVERSED">REVERSED (Reversed Vouchers)</option>
            </Select>
          </div>

          <div className="flex justify-end">
            <Button
              type="button"
              variant="secondary"
              onClick={() =>
                setFilters({
                  from: firstOfMonth,
                  to: today.toISOString().slice(0, 10),
                  status: undefined,
                  limit: 50,
                })
              }
              className="w-full sm:w-auto"
            >
              <RotateCcw className="w-3.5 h-3.5 mr-1" />
              <span>Reset Filters</span>
            </Button>
          </div>
        </div>
      </div>

      {/* Table Container */}
      <div className="bg-paper-surface border border-paper-border rounded-lg overflow-hidden shadow-subtle">
        {isLoading ? (
          <div className="p-4 space-y-2">
            {[1, 2, 3, 4, 5, 6].map((i) => (
              <Skeleton key={i} className="h-10 w-full" />
            ))}
          </div>
        ) : error ? (
          <div className="p-8 text-center text-xs text-ledger-red">
            Failed to retrieve journal entries: {(error as Error).message}
          </div>
        ) : entries.length === 0 ? (
          <div className="p-16 text-center">
            <div className="w-12 h-12 rounded-full bg-paper-alt flex items-center justify-center text-paper-muted mx-auto mb-3 border border-paper-border">
              <FileText className="w-6 h-6" />
            </div>
            <p className="text-sm font-medium text-paper-text mb-1">
              No journal entries found in this period.
            </p>
            <p className="text-xs text-paper-muted max-w-sm mx-auto mb-4">
              Try adjusting the date range filters or create a new journal voucher.
            </p>
            <Link to="/journal-entries/new">
              <Button variant="secondary" size="sm">
                + Create First Voucher [F7]
              </Button>
            </Link>
          </div>
        ) : (
          <JournalEntryListTable entries={entries} />
        )}
      </div>
    </div>
  );
};

