import React, { useState } from 'react';
import { Plus, Building2, CheckCircle, RefreshCw } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Skeleton } from '../../components/ui/skeleton';
import { BankAccountForm } from '../../components/bankAccounts/BankAccountForm';
import { useBankAccounts } from '../../hooks/useBankAccounts';
import { useAccounts } from '../../hooks/useAccounts';

export const BankAccountsPage: React.FC = () => {
  const { bankAccounts = [], isLoading, refetch } = useBankAccounts();
  const { accounts = [] } = useAccounts();
  const [showForm, setShowForm] = useState(false);

  const accountMap = React.useMemo(() => {
    return new Map(accounts.map((a) => [a.id, a]));
  }, [accounts]);

  return (
    <div className="space-y-5 max-w-6xl mx-auto pb-10">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-paper-border pb-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-xl font-serif font-bold text-brand-navy">
              Bank Account Register
            </h1>
            <span className="key-tag text-[10px] bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border text-paper-muted">
              BANKING
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-0.5">
            Configure company bank accounts, IBAN/SWIFT numbers, and links to General Ledger asset accounts.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => refetch()}
            className="text-xs border-paper-border text-paper-muted hover:text-paper-text"
            title="Refresh Bank Accounts"
          >
            <RefreshCw className="h-3.5 w-3.5 mr-1" />
            Refresh
          </Button>

          <Button
            onClick={() => setShowForm(true)}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4 shadow-sm flex items-center gap-1.5"
          >
            <Plus className="h-4 w-4" />
            <span>New Bank Account</span>
          </Button>
        </div>
      </div>

      {/* Content Table / Empty State */}
      <div className="bg-white border border-paper-border rounded-md overflow-hidden shadow-subtle">
        {isLoading ? (
          <div className="p-4 space-y-3">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
        ) : bankAccounts.length === 0 ? (
          <div className="p-12 text-center space-y-3">
            <div className="mx-auto w-12 h-12 rounded-full bg-paper-alt flex items-center justify-center text-paper-muted border border-paper-border">
              <Building2 className="h-6 w-6 text-brand-navy" />
            </div>
            <h3 className="font-serif text-base font-bold text-brand-navy">
              No Bank Accounts Registered
            </h3>
            <p className="text-xs text-paper-muted max-w-sm mx-auto">
              Add your business bank account to start recording wire transfers, cheques, and Fonepay settlements.
            </p>
            <Button
              onClick={() => setShowForm(true)}
              size="sm"
              className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif mt-2"
            >
              + Add First Bank Account
            </Button>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-xs border-collapse min-w-[750px]">
              <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
                <tr>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-28">
                    Code
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
                    Account Name
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
                    Bank Name
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-36">
                    Account #
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-32">
                    IFSC / Branch
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
                    Linked GL Account
                  </th>
                  <th className="px-2.5 py-2.5 font-serif uppercase tracking-wider text-center w-24">
                    Default
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-paper-border">
                {bankAccounts.map((b) => {
                  const glAccount = accountMap.get(b.glAccountId);

                  return (
                    <tr
                      key={b.id}
                      className="hover:bg-paper-warm/30 transition-colors"
                    >
                      <td className="px-3 py-2.5 font-mono font-bold text-brand-navy border-r border-paper-border">
                        {b.accountCode}
                      </td>
                      <td className="px-3 py-2.5 font-medium text-paper-text border-r border-paper-border">
                        {b.accountName}
                      </td>
                      <td className="px-3 py-2.5 text-paper-muted border-r border-paper-border">
                        {b.bankName || '—'}
                      </td>
                      <td className="px-3 py-2.5 font-mono text-paper-text border-r border-paper-border">
                        {b.accountNumber || '—'}
                      </td>
                      <td className="px-3 py-2.5 font-mono text-paper-muted border-r border-paper-border">
                        {b.ifscCode || '—'}
                      </td>
                      <td className="px-3 py-2.5 border-r border-paper-border">
                        {glAccount ? (
                          <div className="flex items-center gap-1.5">
                            <span className="font-mono text-[10px] text-paper-muted">
                              {glAccount.accountCode}
                            </span>
                            <span className="font-medium text-paper-text">
                              {glAccount.accountName}
                            </span>
                          </div>
                        ) : (
                          <span className="text-paper-muted font-mono">
                            GL #{b.glAccountId}
                          </span>
                        )}
                      </td>
                      <td className="px-2.5 py-2.5 text-center">
                        {b.defaultAccount ? (
                          <span className="inline-flex items-center gap-1 text-[11px] font-semibold text-[#2d6a4f] bg-[#eaf4ef] border border-[#2d6a4f]/30 px-2 py-0.5 rounded">
                            <CheckCircle className="h-3 w-3" />
                            Primary
                          </span>
                        ) : (
                          <span className="text-paper-muted text-[11px]">—</span>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}

        <div className="bg-paper-alt px-4 py-2 border-t border-paper-border flex items-center justify-between text-xs text-paper-muted">
          <span>{bankAccounts.length} bank account(s) registered</span>
          <span className="font-serif italic text-[11px]">
            Connected with Double-Entry General Ledger
          </span>
        </div>
      </div>

      <BankAccountForm open={showForm} onClose={() => setShowForm(false)} />
    </div>
  );
};
