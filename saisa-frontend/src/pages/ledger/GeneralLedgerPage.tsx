import React from 'react';
import { useSearchParams } from 'react-router-dom';
import { LedgerFilterBar } from '../../components/ledger/LedgerFilterBar';
import { LedgerTable } from '../../components/ledger/LedgerTable';
import { Skeleton } from '../../components/ui/skeleton';
import { useLedger } from '../../hooks/useLedger';
import { useAccounts } from '../../hooks/useAccounts';
import { useAuth } from '../../hooks/useAuth';
import { BookOpen } from 'lucide-react';

export const GeneralLedgerPage: React.FC = () => {
  const [params, setParams] = useSearchParams();
  const { user } = useAuth();

  const today = new Date();
  const firstOfMonth = new Date(today.getFullYear(), today.getMonth(), 1)
    .toISOString()
    .slice(0, 10);

  const accountId = params.get('accountId')
    ? Number(params.get('accountId'))
    : null;
  const from = params.get('from') ?? firstOfMonth;
  const to = params.get('to') ?? today.toISOString().slice(0, 10);

  const { accounts = [] } = useAccounts();
  const selectedAccount = accounts.find((a) => a.id === accountId);

  const {
    data: statement,
    isLoading,
    error,
  } = useLedger(accountId ?? 0, from, to);

  const handleAccountChange = (id: number) => {
    setParams((prev) => {
      const next = new URLSearchParams(prev);
      if (id) {
        next.set('accountId', String(id));
      } else {
        next.delete('accountId');
      }
      return next;
    });
  };

  const handleFromChange = (v: string) => {
    setParams((prev) => {
      const next = new URLSearchParams(prev);
      next.set('from', v);
      return next;
    });
  };

  const handleToChange = (v: string) => {
    setParams((prev) => {
      const next = new URLSearchParams(prev);
      next.set('to', v);
      return next;
    });
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="no-print pb-4 border-b border-paper-border">
        <h1 className="font-serif text-2xl font-bold text-brand-navy">
          General Ledger (GL) Statement
        </h1>
        <p className="text-xs text-paper-muted mt-1">
          Complete chronological record of all debit and credit movements with continuous running balances.
        </p>
      </div>

      {/* Filter Bar */}
      <LedgerFilterBar
        accountId={accountId}
        from={from}
        to={to}
        onAccountChange={handleAccountChange}
        onFromChange={handleFromChange}
        onToChange={handleToChange}
        onPrint={() => window.print()}
      />

      {/* Content */}
      {!accountId ? (
        <div className="bg-paper-surface border border-paper-border rounded-lg p-16 text-center shadow-subtle">
          <BookOpen className="w-10 h-10 text-paper-muted/60 mx-auto mb-3" />
          <p className="text-sm font-medium text-paper-text mb-1">
            No Account Selected
          </p>
          <p className="text-xs text-paper-muted max-w-sm mx-auto">
            Choose any Chart of Account from the dropdown above to inspect its real-time transaction ledger and closing balance.
          </p>
        </div>
      ) : isLoading ? (
        <div className="space-y-3 p-2 bg-paper-surface border border-paper-border rounded-lg">
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <Skeleton key={i} className="h-10 w-full" />
          ))}
        </div>
      ) : error ? (
        <div className="card p-8 text-center text-xs text-ledger-red border-ledger-red/30">
          Failed to load ledger statement: {(error as Error).message}
        </div>
      ) : statement && statement.entries.length === 0 ? (
        <div className="bg-paper-surface border border-paper-border rounded-lg p-16 text-center shadow-subtle">
          <div className="w-10 h-10 rounded-full bg-paper-alt flex items-center justify-center text-paper-muted mx-auto mb-3 border border-paper-border font-mono text-xs">
            0
          </div>
          <p className="text-sm font-medium text-paper-text mb-1">
            No transactions found for {selectedAccount?.accountName}
          </p>
          <p className="text-xs text-paper-muted max-w-sm mx-auto">
            There are no posted journal vouchers touching account #{selectedAccount?.accountCode} in the selected date range ({from} to {to}).
          </p>
        </div>
      ) : statement && selectedAccount ? (
        <div className="bg-paper-surface border border-paper-border rounded-lg p-5 shadow-subtle">
          <LedgerTable
            statement={statement}
            accountName={selectedAccount.accountName}
            accountCode={selectedAccount.accountCode}
            accountType={selectedAccount.accountType}
            companyName={user?.tenantCode ? `${user.tenantCode.toUpperCase()} Traders` : 'Acme Traders Pvt. Ltd.'}
            from={from}
            to={to}
          />
        </div>
      ) : null}
    </div>
  );
};
