import React from 'react';
import type { PaymentStatus } from '../../types/payment';

interface Props {
  status: PaymentStatus;
}

const STYLES: Record<PaymentStatus, { bg: string; text: string; label: string }> = {
  DRAFT: {
    bg: 'bg-amber-50',
    text: 'text-amber-700 border-amber-200',
    label: '○ DRAFT',
  },
  POSTED: {
    bg: 'bg-emerald-50',
    text: 'text-emerald-700 border-emerald-200',
    label: '✓ POSTED',
  },
  REVERSED: {
    bg: 'bg-gray-100',
    text: 'text-gray-600 border-gray-300',
    label: '✕ REVERSED',
  },
};

export const PaymentStatusBadge: React.FC<Props> = ({ status }) => {
  const s = STYLES[status] || STYLES.POSTED;
  return (
    <span
      className={`inline-block font-mono text-[10px] uppercase tracking-wider font-medium px-2 py-0.5 rounded border ${s.bg} ${s.text}`}
    >
      {s.label}
    </span>
  );
};

