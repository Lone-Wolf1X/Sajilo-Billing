import * as React from 'react';
import { cn } from '@/lib/utils';

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {
  error?: string;
  hint?: string;
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, error, hint, id, ...props }, ref) => {
    return (
      <div className="w-full">
        <input
          id={id}
          ref={ref}
          className={cn(
            'form-input',
            error && 'border-ledger-red focus:border-ledger-red focus:shadow-[0_0_0_3px_#f9e8e8]',
            className
          )}
          {...props}
        />
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

Input.displayName = 'Input';

