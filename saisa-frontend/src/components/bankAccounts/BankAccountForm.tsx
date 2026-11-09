import React, { useState } from 'react';
import { Dialog } from '../ui/dialog';
import { Input } from '../ui/input';
import { Label } from '../ui/label';
import { Button } from '../ui/button';
import { AccountCombobox } from '../journal/AccountCombobox';
import { useCreateBankAccount } from '../../hooks/useBankAccounts';

interface Props {
  open: boolean;
  onClose: () => void;
}

export const BankAccountForm: React.FC<Props> = ({ open, onClose }) => {
  const createMutation = useCreateBankAccount();

  const [accountCode, setAccountCode] = useState('');
  const [accountName, setAccountName] = useState('');
  const [bankName, setBankName] = useState('');
  const [accountNumber, setAccountNumber] = useState('');
  const [ifscCode, setIfscCode] = useState('');
  const [glAccountId, setGlAccountId] = useState<number | null>(null);
  const [isDefault, setIsDefault] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!glAccountId) {
      setErrorMsg('Please select a linked General Ledger asset account.');
      return;
    }
    setErrorMsg(null);

    try {
      await createMutation.mutateAsync({
        accountCode: accountCode.trim().toUpperCase(),
        accountName: accountName.trim(),
        bankName: bankName.trim() || undefined,
        accountNumber: accountNumber.trim() || undefined,
        ifscCode: ifscCode.trim() || undefined,
        glAccountId,
        defaultAccount: isDefault,
      });
      // reset form
      setAccountCode('');
      setAccountName('');
      setBankName('');
      setAccountNumber('');
      setIfscCode('');
      setGlAccountId(null);
      setIsDefault(false);
      onClose();
    } catch (err: any) {
      setErrorMsg(
        err.response?.data?.message || err.message || 'Failed to create bank account.'
      );
    }
  };

  return (
    <Dialog
      open={open}
      onClose={onClose}
      title="New Bank Account"
      description="Register a company bank account and map it to an Asset Ledger in Chart of Accounts."
    >
      <form onSubmit={handleSubmit} className="space-y-3.5">
        {errorMsg && (
          <div className="bg-[#fdf2f2] border border-[#7a2e2e] text-[#7a2e2e] text-xs p-2.5 rounded-sm">
            {errorMsg}
          </div>
        )}

        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label className="text-xs font-serif font-bold text-paper-text">
              Account Code *
            </Label>
            <Input
              value={accountCode}
              onChange={(e) => setAccountCode(e.target.value)}
              placeholder="e.g. NABIL-01"
              className="font-mono text-xs mt-1"
              required
            />
          </div>
          <div>
            <Label className="text-xs font-serif font-bold text-paper-text">
              Account Name / Alias *
            </Label>
            <Input
              value={accountName}
              onChange={(e) => setAccountName(e.target.value)}
              placeholder="e.g. Nabil Operating A/c"
              className="text-xs mt-1"
              required
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label className="text-xs font-serif text-paper-text">
              Bank Institution Name
            </Label>
            <Input
              value={bankName}
              onChange={(e) => setBankName(e.target.value)}
              placeholder="e.g. Nabil Bank Ltd."
              className="text-xs mt-1"
            />
          </div>
          <div>
            <Label className="text-xs font-serif text-paper-text">
              Bank Account Number
            </Label>
            <Input
              value={accountNumber}
              onChange={(e) => setAccountNumber(e.target.value)}
              placeholder="e.g. 01201017500021"
              className="font-mono text-xs mt-1"
            />
          </div>
        </div>

        <div>
          <Label className="text-xs font-serif text-paper-text">
            Branch Code / SWIFT / IFSC
          </Label>
          <Input
            value={ifscCode}
            onChange={(e) => setIfscCode(e.target.value)}
            placeholder="e.g. NARBLNPK / KDR001"
            className="font-mono text-xs mt-1"
          />
        </div>

        <div>
          <Label className="text-xs font-serif font-bold text-paper-text">
            Linked GL Account (Asset) *
          </Label>
          <div className="mt-1">
            <AccountCombobox
              value={glAccountId}
              onChange={setGlAccountId}
              placeholder="Search Bank / Cash asset account..."
            />
          </div>
          <p className="text-[11px] text-paper-muted mt-1 italic">
            All bank adjustments, deposits, and payments will post double-entry vouchers to this GL account.
          </p>
        </div>

        <div className="pt-1">
          <label className="flex items-center gap-2 text-xs text-paper-text cursor-pointer">
            <input
              type="checkbox"
              checked={isDefault}
              onChange={(e) => setIsDefault(e.target.checked)}
              className="rounded border-paper-border text-brand-navy focus:ring-brand-navy"
            />
            <span>Set as primary default bank account for payments</span>
          </label>
        </div>

        <div className="flex items-center justify-end gap-2 pt-3 border-t border-paper-border mt-4">
          <Button
            type="button"
            variant="outline"
            onClick={onClose}
            className="text-xs border-paper-border"
          >
            Cancel
          </Button>
          <Button
            type="submit"
            disabled={createMutation.isPending || !glAccountId}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4"
          >
            {createMutation.isPending ? 'Saving...' : 'Create Bank Account'}
          </Button>
        </div>
      </form>
    </Dialog>
  );
};
