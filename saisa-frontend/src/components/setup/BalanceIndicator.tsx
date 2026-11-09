import React from 'react';
import { CheckCircle2, AlertCircle } from 'lucide-react';
import { formatMoney } from '../../lib/invoiceUtils';

interface Props {
  totalDebits: number;
  totalCredits: number;
}

const TOLERANCE = 0.01;

export const BalanceIndicator: React.FC<Props> = ({ totalDebits, totalCredits }) => {
  const diff = totalDebits - totalCredits;
  const isBalanced = Math.abs(diff) < TOLERANCE;
  const hasValues = totalDebits > 0 || totalCredits > 0;

  if (!hasValues) {
    return (
      <div className="text-xs text-neutral-500 italic">
        सन्तुलन हेर्न रकमहरू प्रविष्ट गर्नुहोस् (Enter amounts to check balance equation)
      </div>
    );
  }

  if (isBalanced) {
    return (
      <div className="inline-flex items-center gap-2 px-3.5 py-2 rounded-md bg-emerald-50 border border-emerald-300 text-emerald-900 text-xs sm:text-sm shadow-sm">
        <CheckCircle2 className="w-4 h-4 text-emerald-600 flex-shrink-0" />
        <span className="font-bold">सन्तुलित (Balanced ✓)</span>
        <span className="text-xs opacity-90">
          सम्पत्ति = दायित्व + पुँजी (Assets = Liabilities + Equity) • {formatMoney(totalDebits.toFixed(2))}
        </span>
      </div>
    );
  }

  return (
    <div className="inline-flex items-center gap-2 px-3.5 py-2 rounded-md bg-rose-50 border border-rose-300 text-rose-900 text-xs sm:text-sm shadow-sm">
      <AlertCircle className="w-4 h-4 text-rose-600 flex-shrink-0" />
      <span className="font-bold">असन्तुलित (Unbalanced ⚠️)</span>
      <span className="text-xs font-mono">
        Dr {formatMoney(totalDebits.toFixed(2))} ≠ Cr {formatMoney(totalCredits.toFixed(2))}
        {' • फरक: '}
        {formatMoney(Math.abs(diff).toFixed(2))}
      </span>
    </div>
  );
};

