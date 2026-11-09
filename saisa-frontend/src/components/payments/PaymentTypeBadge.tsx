import React from 'react';
import { ArrowDownLeft, ArrowUpRight } from 'lucide-react';
import type { PartyType } from '../../types/payment';

interface Props {
  partyType: PartyType;
}

export const PaymentTypeBadge: React.FC<Props> = ({ partyType }) => {
  const isReceipt = partyType === 'CUSTOMER';

  return (
    <span
      className={`inline-flex items-center gap-1 font-mono text-[10px] uppercase tracking-wider font-semibold px-2 py-0.5 rounded border ${
        isReceipt
          ? 'bg-emerald-50 text-emerald-800 border-emerald-200'
          : 'bg-rose-50 text-rose-800 border-rose-200'
      }`}
    >
      {isReceipt ? (
        <ArrowDownLeft className="h-3 w-3 text-emerald-600" />
      ) : (
        <ArrowUpRight className="h-3 w-3 text-rose-600" />
      )}
      <span>{isReceipt ? 'Receipt (In)' : 'Payment (Out)'}</span>
    </span>
  );
};
