import React from 'react';
import { Badge } from '../ui/badge';
import type { InvoiceStatus, PaymentStatus } from '../../types/salesInvoice';

interface InvoiceStatusBadgeProps {
  status: InvoiceStatus | string;
}

interface PaymentStatusBadgeProps {
  status: PaymentStatus;
}

export const InvoiceStatusBadge: React.FC<InvoiceStatusBadgeProps> = ({ status }) => {
  const s = status.toUpperCase();

  switch (s) {
    case 'ISSUED':
      return (
        <Badge
          className="border-[#1e3a5f] bg-[#eef3f9] text-[#1e3a5f] font-mono text-[10px] tracking-wider px-2 py-0.5"
        >
          ● ISSUED
        </Badge>
      );
    case 'PAID':
      return (
        <Badge
          variant="posted"
          className="font-mono text-[10px] tracking-wider px-2 py-0.5"
        >
          ✓ PAID
        </Badge>
      );
    case 'PARTIALLY_PAID':
      return (
        <Badge
          variant="warning"
          className="font-mono text-[10px] tracking-wider px-2 py-0.5"
        >
          PARTIAL
        </Badge>
      );
    case 'CANCELLED':
      return (
        <Badge
          variant="reversed"
          className="font-mono text-[10px] tracking-wider px-2 py-0.5"
        >
          ✕ CANCELLED
        </Badge>
      );
    case 'DRAFT':
    default:
      return (
        <Badge
          variant="draft"
          className="font-mono text-[10px] tracking-wider px-2 py-0.5"
        >
          ○ DRAFT
        </Badge>
      );
  }
};

export const PaymentStatusBadge: React.FC<PaymentStatusBadgeProps> = ({ status }) => {
  switch (status) {
    case 'PAID':
      return (
        <Badge
          variant="posted"
          className="font-mono text-[10px] tracking-wider px-2 py-0.5"
        >
          PAID
        </Badge>
      );
    case 'PARTIALLY_PAID':
      return (
        <Badge
          variant="warning"
          className="font-mono text-[10px] tracking-wider px-2 py-0.5"
        >
          PARTIAL
        </Badge>
      );
    case 'OVERDUE':
      return (
        <Badge
          variant="danger"
          className="font-mono text-[10px] font-bold tracking-wider px-2 py-0.5 animate-pulse"
        >
          OVERDUE
        </Badge>
      );
    case 'UNPAID':
    default:
      return (
        <Badge
          className="border-[#7a7365] bg-[#f5f2ea] text-[#7a7365] font-mono text-[10px] tracking-wider px-2 py-0.5"
        >
          UNPAID
        </Badge>
      );
  }
};
