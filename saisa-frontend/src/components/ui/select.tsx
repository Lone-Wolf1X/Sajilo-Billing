import * as React from 'react';
import { cn } from '@/lib/utils';
import { ChevronDown } from 'lucide-react';

export interface SelectProps
  extends React.SelectHTMLAttributes<HTMLSelectElement> {
  error?: string;
  hint?: string;
}

export const Select = React.forwardRef<HTMLSelectElement, SelectProps>(
  ({ className, error, hint, children, ...props }, ref) => {
    return (
      <div className="w-full relative">
        <div className="relative">
          <select
            ref={ref}
            className={cn(
              'form-select appearance-none pr-8 cursor-pointer',
              error &&
                'border-ledger-red focus:border-ledger-red focus:shadow-[0_0_0_3px_#f9e8e8]',
              className
            )}
            {...props}
          >
            {children}
          </select>
          <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2.5 text-paper-muted">
            <ChevronDown className="w-3.5 h-3.5" />
          </div>
        </div>
        {hint && !error && (
          <p className="text-xs text-paper-muted mt-1">{hint}</p>
        )}
        {error && (
          <p className="text-xs text-ledger-red mt-1 font-medium">{error}</p>
        )}
      </div>
    );
  }
);

Select.displayName = 'Select';

