import React from 'react';
import { Link } from 'react-router-dom';
import { BookOpen, Plus, Lock, CheckCircle2, XCircle } from 'lucide-react';
import { AccountTypeBadge } from './AccountTypeBadge';
import type { ChartOfAccount } from '../../types/account';

interface Props {
  account: ChartOfAccount;
  onEdit: () => void;
}

export const AccountDetailPanel: React.FC<Props> = ({ account, onEdit }) => {
  return (
    <div className="bg-paper-surface border border-paper-border rounded-lg p-5 shadow-subtle">
      <div className="flex items-start justify-between gap-2 mb-4 pb-3 border-b border-paper-border">
        <div>
          <span className="font-mono text-xs font-bold text-brand-navy bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border">
            {account.accountCode}
          </span>
          <h2 className="font-serif font-bold text-lg text-brand-navy mt-1.5">
            {account.accountName}
          </h2>
        </div>
        <AccountTypeBadge type={account.accountType} />
      </div>

      <div className="space-y-2.5 text-xs">
        <div className="flex justify-between items-center py-1 border-b border-dashed border-paper-border">
          <span className="text-paper-muted">Account Status:</span>
          <span className="flex items-center gap-1 font-semibold">
            {account.active ? (
              <span className="text-ledger-green flex items-center gap-1">
                <CheckCircle2 className="w-3.5 h-3.5" /> Active
              </span>
            ) : (
              <span className="text-paper-muted flex items-center gap-1">
                <XCircle className="w-3.5 h-3.5" /> Inactive
              </span>
            )}
          </span>
        </div>

        <div className="flex justify-between items-center py-1 border-b border-dashed border-paper-border">
          <span className="text-paper-muted">Normal Balance:</span>
          <span className="font-mono font-medium text-paper-text">
            {account.accountType === 'ASSET' || account.accountType === 'EXPENSE'
              ? 'Debit (Dr)'
              : 'Credit (Cr)'}
          </span>
        </div>

        <div className="flex justify-between items-center py-1 border-b border-dashed border-paper-border">
          <span className="text-paper-muted">Financial Statement:</span>
          <span className="text-paper-text font-medium">
            {account.accountType === 'INCOME' || account.accountType === 'EXPENSE'
              ? 'Profit & Loss (P&L)'
              : 'Balance Sheet'}
          </span>
        </div>

        {account.systemAccount && (
          <div className="flex justify-between items-center py-1 border-b border-dashed border-paper-border">
            <span className="text-paper-muted">System Controlled:</span>
            <span className="flex items-center gap-1 text-ledger-amber font-semibold">
              <Lock className="w-3.5 h-3.5" /> Immutable Core
            </span>
          </div>
        )}
      </div>

      <div className="mt-5 pt-4 border-t border-paper-border space-y-2">
        <Link
          to={`/ledger?accountId=${account.id}`}
          className="btn btn-secondary w-full justify-start text-xs font-medium"
        >
          <BookOpen className="w-3.5 h-3.5 mr-1.5 text-brand-navy" />
          <span>View General Ledger Statement</span>
        </Link>

        <Link
          to={`/journal-entries/new?accountId=${account.id}`}
          className="btn btn-secondary w-full justify-start text-xs font-medium"
        >
          <Plus className="w-3.5 h-3.5 mr-1.5 text-brand-maroon" />
          <span>Post Journal Voucher [F7]</span>
        </Link>

        {!account.systemAccount && (
          <button
            type="button"
            onClick={onEdit}
            className="btn btn-secondary w-full justify-start text-xs font-medium cursor-pointer"
          >
            <span>Edit Account Details</span>
          </button>
        )}
      </div>
    </div>
  );
};

