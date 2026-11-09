import React from 'react';
import { Label } from '../ui/label';
import { Input } from '../ui/input';
import { useBankAccounts } from '../../hooks/useBankAccounts';
import { PAYMENT_METHODS, methodNeedsBank } from '../../lib/paymentUtils';
import type { PaymentMethod } from '../../types/payment';

interface Props {
  method: PaymentMethod;
  bankAccountId: number | null;
  referenceNo: string;
  onMethodChange: (m: PaymentMethod) => void;
  onBankAccountChange: (id: number | null) => void;
  onReferenceChange: (r: string) => void;
}

export const PaymentMethodSelector: React.FC<Props> = ({
  method,
  bankAccountId,
  referenceNo,
  onMethodChange,
  onBankAccountChange,
  onReferenceChange,
}) => {
  const { bankAccounts = [] } = useBankAccounts();
  const needsBank = methodNeedsBank(method);

  return (
    <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
      <div>
        <Label className="text-xs font-serif font-bold text-paper-text">
          Payment Method *
        </Label>
        <select
          value={method}
          onChange={(e) => onMethodChange(e.target.value as PaymentMethod)}
          className="w-full h-9 rounded-sm border border-paper-border bg-white px-2.5 text-xs text-paper-text focus:outline-none focus:ring-1 focus:ring-brand-navy mt-1"
        >
          {PAYMENT_METHODS.map((m) => (
            <option key={m.value} value={m.value}>
              {m.label}
            </option>
          ))}
        </select>
      </div>

      {needsBank && (
        <div>
          <Label className="text-xs font-serif font-bold text-paper-text">
            Bank Account *
          </Label>
          <select
            value={bankAccountId ?? ''}
            onChange={(e) =>
              onBankAccountChange(e.target.value ? Number(e.target.value) : null)
            }
            className="w-full h-9 rounded-sm border border-paper-border bg-white px-2.5 text-xs text-paper-text focus:outline-none focus:ring-1 focus:ring-brand-navy mt-1"
          >
            <option value="">Select bank account...</option>
            {bankAccounts.map((b) => (
              <option key={b.id} value={b.id}>
                {b.bankName ? `${b.bankName} - ` : ''}
                {b.accountName} {b.accountNumber ? `(${b.accountNumber})` : ''}
              </option>
            ))}
          </select>
        </div>
      )}

      <div>
        <Label className="text-xs font-serif text-paper-text">
          Reference / Instrument #
        </Label>
        <Input
          value={referenceNo}
          onChange={(e) => onReferenceChange(e.target.value)}
          placeholder={
            method === 'CHEQUE'
              ? 'Cheque / Draft Number'
              : 'UTR / Transaction Reference'
          }
          className="text-xs h-9 bg-white mt-1 font-mono"
        />
      </div>
    </div>
  );
};
