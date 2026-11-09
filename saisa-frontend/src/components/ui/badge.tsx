import * as React from 'react';
import { cn } from '@/lib/utils';

export interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?:
    | 'default'
    | 'success'
    | 'warning'
    | 'danger'
    | 'asset'
    | 'liability'
    | 'equity'
    | 'income'
    | 'expense'
    | 'draft'
    | 'posted'
    | 'reversed';
}

export const Badge: React.FC<BadgeProps> = ({
  className,
  variant = 'default',
  children,
  ...props
}) => {
  const variantStyles: Record<string, string> = {
    default: 'badge-default',
    success: 'badge-success',
    warning: 'badge-warning',
    danger: 'badge-danger',
    posted: 'bg-ledger-green-light text-ledger-green border-[#b7ddcb]',
    draft: 'bg-ledger-amber-light text-ledger-amber border-[#fae4a8]',
    reversed: 'bg-ledger-red-light text-ledger-red border-[#f3bebe]',
    asset: 'bg-emerald-50 text-emerald-800 border-emerald-200',
    liability: 'bg-amber-50 text-amber-800 border-amber-200',
    equity: 'bg-indigo-50 text-indigo-800 border-indigo-200',
    income: 'bg-blue-50 text-blue-800 border-blue-200',
    expense: 'bg-rose-50 text-rose-800 border-rose-200',
  };

  return (
    <span
      className={cn(
        'badge font-medium text-xs rounded border px-2 py-0.5 inline-flex items-center gap-1',
        variantStyles[variant] || 'badge-default',
        className
      )}
      {...props}
    >
      {children}
    </span>
  );
};
