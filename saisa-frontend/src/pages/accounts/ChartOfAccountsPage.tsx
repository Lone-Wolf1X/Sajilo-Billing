import React, { useMemo, useState } from 'react';
import { useAccounts } from '../../hooks/useAccounts';
import { buildAccountTree, filterAccounts } from '../../lib/accountTree';
import { AccountForm } from '../../components/accounts/AccountForm';
import { AccountDetailPanel } from '../../components/accounts/AccountDetailPanel';
import { AccountTypeSection } from '../../components/accounts/AccountTypeSection';
import { SearchFilterBar } from '../../components/accounts/SearchFilterBar';
import { Skeleton } from '../../components/ui/skeleton';
import { Button } from '../../components/ui/button';
import { Plus, BookOpen, AlertCircle } from 'lucide-react';
import type { AccountType, ChartOfAccount } from '../../types/account';
import type { AccountNode } from '../../lib/accountTree';

export const ChartOfAccountsPage: React.FC = () => {
  const { accounts, isLoading, isError, error, refetch } = useAccounts();

  const [search, setSearch] = useState('');
  const [typeFilter, setTypeFilter] = useState<AccountType | 'ALL'>('ALL');
  const [selected, setSelected] = useState<ChartOfAccount | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [editingAccount, setEditingAccount] = useState<ChartOfAccount | null>(null);
  const [formDefaultType, setFormDefaultType] = useState<AccountType | undefined>();

  const { filteredAccounts, highlightIds, expandIds } = useMemo(() => {
    if (!accounts || accounts.length === 0) {
      return {
        filteredAccounts: [],
        highlightIds: new Set<number>(),
        expandIds: new Set<number>(),
      };
    }
    let base = accounts;
    if (typeFilter !== 'ALL') {
      base = base.filter((a) => a.accountType === typeFilter);
    }
    return filterAccounts(base, search);
  }, [accounts, search, typeFilter]);

  const groups = useMemo(
    () => buildAccountTree(filteredAccounts),
    [filteredAccounts]
  );

  const handleSelect = (node: AccountNode) => setSelected(node);

  const handleAddInType = (type: AccountType) => {
    setEditingAccount(null);
    setFormDefaultType(type);
    setShowForm(true);
  };

  const handleAddGeneric = () => {
    setEditingAccount(null);
    setFormDefaultType(undefined);
    setShowForm(true);
  };

  const handleEdit = () => {
    if (!selected) return;
    setEditingAccount(selected);
    setShowForm(true);
  };

  if (isError) {
    return (
      <div className="card p-8 text-center max-w-lg mx-auto my-8 border-ledger-red/30 bg-ledger-red-light/30">
        <AlertCircle className="w-10 h-10 text-ledger-red mx-auto mb-3" />
        <h2 className="font-serif font-bold text-lg text-ledger-red mb-1">
          Unable to Load Chart of Accounts
        </h2>
        <p className="text-xs text-paper-muted mb-4">
          {(error as Error)?.message || 'A network error occurred while connecting to the ledger backend.'}
        </p>
        <Button variant="secondary" onClick={() => refetch()}>
          Retry Connection
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 pb-4 border-b border-paper-border">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="font-serif text-2xl font-bold text-brand-navy">
              Chart of Accounts (COA)
            </h1>
            <span className="text-xs font-mono font-semibold bg-paper-alt px-2 py-0.5 rounded border border-paper-border text-paper-muted">
              {accounts?.length ?? 0} Accounts Total
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-1">
            Hierarchical ledger architecture organizing Assets, Liabilities, Equity, Revenue, and Expense streams.
          </p>
        </div>
      </div>

      {/* Search & Type Filter Bar */}
      <SearchFilterBar
        search={search}
        onSearchChange={setSearch}
        typeFilter={typeFilter}
        onTypeFilterChange={setTypeFilter}
        onCreate={handleAddGeneric}
      />

      {/* Main Split Grid (Tree on Left, Detail on Right) */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
        {/* LEFT PANEL: Hierarchical Tree View */}
        <div className="lg:col-span-2 bg-paper-surface border border-paper-border rounded-lg p-4 min-h-[500px] shadow-subtle">
          {isLoading ? (
            <div className="space-y-3 p-2">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <Skeleton key={i} className="h-9 w-full" />
              ))}
            </div>
          ) : filteredAccounts.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-full text-center py-20 px-4">
              <div className="w-12 h-12 rounded-full bg-paper-alt flex items-center justify-center text-paper-muted mb-3 border border-paper-border">
                <BookOpen className="w-6 h-6" />
              </div>
              <p className="text-sm text-paper-text font-medium mb-1">
                {search || typeFilter !== 'ALL'
                  ? 'No accounts match the current filter criteria.'
                  : 'No chart of accounts established yet.'}
              </p>
              <p className="text-xs text-paper-muted max-w-sm mb-4">
                {search || typeFilter !== 'ALL'
                  ? 'Try clearing your search term or selecting "All Account Classifications".'
                  : 'Initialize your general ledger by adding your first primary account.'}
              </p>

              {!search && typeFilter === 'ALL' && (
                <Button variant="primary" onClick={handleAddGeneric}>
                  <Plus className="w-4 h-4 mr-1" />
                  <span>Add First Account</span>
                </Button>
              )}
            </div>
          ) : (
            <div className="space-y-1">
              {groups.map((g) => (
                <AccountTypeSection
                  key={g.type}
                  group={g}
                  selectedId={selected?.id ?? null}
                  onSelect={handleSelect}
                  highlightIds={highlightIds}
                  forceExpandIds={expandIds}
                  onAddInType={handleAddInType}
                  hasSearchFilter={Boolean(search.trim())}
                />
              ))}
            </div>
          )}
        </div>

        {/* RIGHT PANEL: Selected Account Detail */}
        <div className="sticky top-20">
          {selected ? (
            <AccountDetailPanel account={selected} onEdit={handleEdit} />
          ) : (
            <div className="bg-paper-surface border border-paper-border rounded-lg p-8 text-center text-xs text-paper-muted shadow-subtle">
              <BookOpen className="w-8 h-8 mx-auto text-paper-muted/50 mb-2" />
              <p className="font-medium text-paper-text mb-1">
                No Account Selected
              </p>
              <p>
                Click any ledger account in the tree to review classification, balance attributes, and drill down to statement vouchers.
              </p>
            </div>
          )}
        </div>
      </div>

      {/* Account Creation / Edit Modal Dialog */}
      <AccountForm
        open={showForm}
        onClose={() => setShowForm(false)}
        defaultType={formDefaultType}
        editingAccount={editingAccount}
      />
    </div>
  );
};
