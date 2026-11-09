import React from 'react';
import { CheckCircle2, AlertTriangle } from 'lucide-react';
import { formatMoney } from '@/lib/utils';

interface Props {
  totalDebit: string;
  totalCredit: string;
  isBalanced: boolean;
  hasLines: boolean;
}

export const JournalBalanceIndicator: React.FC<Props> = ({
  totalDebit,
  totalCredit,
  isBalanced,
  hasLines,
}) => {
  if (!hasLines) {
    return (
      <div className="text-xs text-paper-muted italic select-none">
        Enter debit and credit amounts to evaluate ledger equilibrium
      </div>
    );
  }

  const dr = parseFloat(totalDebit) || 0;
  const cr = parseFloat(totalCredit) || 0;
  const diff = Math.abs(dr - cr);

  if (isBalanced) {
    return (
      <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded bg-emerald-50 border border-emerald-300 text-emerald-900 text-xs shadow-sm">
        <CheckCircle2 className="w-4 h-4 text-emerald-600 flex-shrink-0" />
        <span className="font-semibold">Balanced Equilibrium</span>
        <span className="text-[11px] font-mono text-emerald-800">
          Dr {formatMoney(dr)} = Cr {formatMoney(cr)}
        </span>
      </div>
    );
  }

  return (
    <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded bg-rose-50 border border-rose-300 text-rose-900 text-xs shadow-sm">
      <AlertTriangle className="w-4 h-4 text-rose-600 flex-shrink-0" />
      <span className="font-semibold">Unbalanced Voucher</span>
      <span className="text-[11px] font-mono text-rose-800">
        Dr {formatMoney(dr)} vs Cr {formatMoney(cr)} · Gap {formatMoney(diff)}
      </span>
    </div>
  );
};
