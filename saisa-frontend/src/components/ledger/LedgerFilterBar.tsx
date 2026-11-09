import React from 'react';
import { AccountCombobox } from '../journal/AccountCombobox';
import { Input } from '../ui/input';
import { Label } from '../ui/label';
import { Button } from '../ui/button';
import { Printer } from 'lucide-react';

interface Props {
  accountId: number | null;
  from: string;
  to: string;
  onAccountChange: (id: number) => void;
  onFromChange: (v: string) => void;
  onToChange: (v: string) => void;
  onPrint: () => void;
}

export const LedgerFilterBar: React.FC<Props> = ({
  accountId,
  from,
  to,
  onAccountChange,
  onFromChange,
  onToChange,
  onPrint,
}) => {
  return (
    <div className="no-print bg-paper-surface border border-paper-border rounded-lg p-4 mb-4 shadow-subtle">
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 items-end">
        <div className="lg:col-span-2">
          <Label required>Select Ledger Account</Label>
          <AccountCombobox
            value={accountId}
            onChange={onAccountChange}
            placeholder="Select ledger account to view statement..."
          />
        </div>

        <div>
          <Label htmlFor="from">From Date</Label>
          <Input
            id="from"
            type="date"
            value={from}
            onChange={(e) => onFromChange(e.target.value)}
          />
        </div>

        <div>
          <Label htmlFor="to">To Date</Label>
          <Input
            id="to"
            type="date"
            value={to}
            onChange={(e) => onToChange(e.target.value)}
          />
        </div>
      </div>

      <div className="mt-3 pt-3 border-t border-paper-border flex justify-between items-center">
        <span className="text-xs text-paper-muted italic">
          💡 Select any ledger account to inspect running debit/credit balance.
        </span>

        <Button
          type="button"
          variant="secondary"
          size="sm"
          onClick={onPrint}
          disabled={!accountId}
          className="cursor-pointer"
        >
          <Printer className="w-3.5 h-3.5 mr-1 text-brand-navy" />
          <span>Print Statement</span>
        </Button>
      </div>
    </div>
  );
};
