import React, { useState } from 'react';
import { Dialog } from '../ui/dialog';
import { Input } from '../ui/input';
import { Label } from '../ui/label';
import { Button } from '../ui/button';
import { toast } from 'sonner';
import { useReverseJournalEntry } from '../../hooks/useJournalEntries';
import { AlertTriangle } from 'lucide-react';

interface Props {
  entryId: number;
  entryNumber: string;
  open: boolean;
  onClose: () => void;
  onSuccess: (reversalId: number) => void;
}

export const ReverseEntryDialog: React.FC<Props> = ({
  entryId,
  entryNumber,
  open,
  onClose,
  onSuccess,
}) => {
  const [reason, setReason] = useState('');
  const [reversalDate, setReversalDate] = useState(
    new Date().toISOString().slice(0, 10)
  );
  const mutation = useReverseJournalEntry();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (reason.trim().length < 5) {
      toast.error('Reversal reason must be at least 5 characters');
      return;
    }

    try {
      const reversal = await mutation.mutateAsync({
        id: entryId,
        data: { reason: reason.trim(), reversalDate },
      });
      toast.success(`Reversal voucher #${reversal.entryNumber} created`);
      onSuccess(reversal.id);
    } catch {
      // toast is handled in hook
    }
  };

  return (
    <Dialog
      open={open}
      onClose={onClose}
      title={`Reverse Voucher ${entryNumber}`}
      description="Create a cryptographically audited reversal journal entry."
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="p-3 bg-amber-50 border border-amber-200 rounded text-xs text-amber-900 flex items-start gap-2">
          <AlertTriangle className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
          <div>
            <strong>Audit Guarantee:</strong> This will create a mirror reversal entry.
            The original entry ({entryNumber}) remains permanently recorded in the ledger with status REVERSED.
          </div>
        </div>

        <div>
          <Label htmlFor="reversalDate" required>
            Reversal Effective Date
          </Label>
          <Input
            id="reversalDate"
            type="date"
            value={reversalDate}
            onChange={(e) => setReversalDate(e.target.value)}
            required
          />
        </div>

        <div>
          <Label htmlFor="reason" required>
            Reversal Reason{' '}
            <span className="text-xs text-paper-muted font-normal">
              (Min 5 characters)
            </span>
          </Label>
          <textarea
            id="reason"
            className="w-full px-3 py-2 text-xs border border-paper-border-strong rounded-md focus:outline-none focus:border-brand-navy focus:ring-1 focus:ring-brand-navy/20 bg-white"
            rows={3}
            value={reason}
            onChange={(e) => setReason(e.target.value)}
            placeholder="e.g. Inadvertent duplicate posting or incorrect account code used"
            required
          />
        </div>

        <div className="flex justify-end gap-2 pt-2 border-t border-paper-border">
          <Button type="button" variant="secondary" onClick={onClose}>
            Cancel
          </Button>
          <Button
            type="submit"
            variant="danger"
            isLoading={mutation.isPending}
          >
            {mutation.isPending ? 'Posting Reversal...' : 'Post Reversal Voucher'}
          </Button>
        </div>
      </form>
    </Dialog>
  );
};
