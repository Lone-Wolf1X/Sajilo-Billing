import React from 'react';
import type { AccountType } from '../../types/account';

const STYLES: Record<AccountType, { bg: string; text: string; label: string }> = {
  ASSET: { bg: 'bg-emerald-50', text: 'text-emerald-800 border-emerald-200', label: 'Asset' },
  LIABILITY: { bg: 'bg-amber-50', text: 'text-amber-800 border-amber-200', label: 'Liability' },
  EQUITY: { bg: 'bg-indigo-50', text: 'text-indigo-800 border-indigo-200', label: 'Equity' },
  INCOME: { bg: 'bg-blue-50', text: 'text-blue-800 border-blue-200', label: 'Income' },
  EXPENSE: { bg: 'bg-rose-50', text: 'text-rose-800 border-rose-200', label: 'Expense' },
};

export const AccountTypeBadge: React.FC<{ type: AccountType }> = ({ type }) => {
  const s = STYLES[type] || STYLES.ASSET;
  return (
    <span
      className={`inline-block text-[10px] uppercase tracking-wider font-semibold px-2 py-0.5 rounded border ${s.bg} ${s.text}`}
    >
      {s.label}
    </span>
  );
};
