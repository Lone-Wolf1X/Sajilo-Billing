import React, { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Dialog } from '../ui/dialog';
import { Input } from '../ui/input';
import { Label } from '../ui/label';
import { Select } from '../ui/select';
import { Button } from '../ui/button';
import { useAccounts, useCreateAccount } from '../../hooks/useAccounts';
import type { AccountType, ChartOfAccount } from '../../types/account';

const accountSchema = z.object({
  accountCode: z
    .string()
    .min(1, 'Account code is required')
    .max(32, 'Code cannot exceed 32 characters')
    .regex(/^[A-Z0-9-]+$/, 'Uppercase letters, numbers, and hyphens only')
    .transform((val) => val.toUpperCase().trim()),
  accountName: z
    .string()
    .min(1, 'Account name is required')
    .max(255, 'Account name is too long')
    .trim(),
  accountType: z.enum(['ASSET', 'LIABILITY', 'EQUITY', 'INCOME', 'EXPENSE']),
  parentAccountId: z.number().nullable().optional(),
});

type FormData = z.infer<typeof accountSchema>;

interface Props {
  open: boolean;
  onClose: () => void;
  defaultType?: AccountType;
  editingAccount?: ChartOfAccount | null;
}

export const AccountForm: React.FC<Props> = ({
  open,
  onClose,
  defaultType,
  editingAccount,
}) => {
  const isEdit = Boolean(editingAccount);
  const { accounts = [] } = useAccounts();
  const createMutation = useCreateAccount();

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
    watch,
    setValue,
  } = useForm<FormData>({
    resolver: zodResolver(accountSchema),
    defaultValues: {
      accountCode: '',
      accountName: '',
      accountType: defaultType ?? 'ASSET',
      parentAccountId: null,
    },
  });

  const selectedType = watch('accountType');
  const parentCandidates = accounts.filter(
    (a) =>
      a.accountType === selectedType &&
      a.id !== editingAccount?.id && // cannot be own parent
      !a.systemAccount // system accounts shouldn't be mutable child parents
  );

  useEffect(() => {
    if (open) {
      if (editingAccount) {
        reset({
          accountCode: editingAccount.accountCode,
          accountName: editingAccount.accountName,
          accountType: editingAccount.accountType,
          parentAccountId: editingAccount.parentAccountId,
        });
      } else {
        reset({
          accountCode: '',
          accountName: '',
          accountType: defaultType ?? 'ASSET',
          parentAccountId: null,
        });
      }
    }
  }, [open, editingAccount, defaultType, reset]);

  const onSubmit = async (data: FormData) => {
    if (isEdit) {
      // Backend edit is slated for Step 22 advanced admin
      onClose();
      return;
    }

    await createMutation.mutateAsync(
      {
        accountCode: data.accountCode,
        accountName: data.accountName,
        accountType: data.accountType,
        parentAccountId: data.parentAccountId ?? null,
      },
      {
        onSuccess: () => {
          reset();
          onClose();
        },
      }
    );
  };

  return (
    <Dialog
      open={open}
      onClose={onClose}
      title={isEdit ? 'Edit Account' : 'New Chart of Account'}
      description="Define an account in your double-entry general ledger."
    >
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div>
          <Label htmlFor="accountCode" required>
            Account Code
          </Label>
          <Input
            id="accountCode"
            {...register('accountCode')}
            disabled={isEdit}
            placeholder="e.g. 1101 or CASH-01"
            maxLength={32}
            error={errors.accountCode?.message}
          />
          <p className="text-[11px] text-paper-muted mt-1">
            Unique identifier (e.g. 1000s for Assets, 2000s for Liabilities).
          </p>
        </div>

        <div>
          <Label htmlFor="accountName" required>
            Account Name
          </Label>
          <Input
            id="accountName"
            {...register('accountName')}
            placeholder="e.g. Petty Cash Vault"
            error={errors.accountName?.message}
          />
        </div>

        <div>
          <Label htmlFor="accountType" required>
            Account Classification (Type)
          </Label>
          <Select
            id="accountType"
            {...register('accountType')}
            disabled={isEdit}
            value={selectedType}
            onChange={(e) => {
              setValue('accountType', e.target.value as AccountType);
              setValue('parentAccountId', null);
            }}
          >
            <option value="ASSET">Asset (Normal Debit Balance)</option>
            <option value="LIABILITY">Liability (Normal Credit Balance)</option>
            <option value="EQUITY">Equity (Normal Credit Balance)</option>
            <option value="INCOME">Income / Revenue (Normal Credit Balance)</option>
            <option value="EXPENSE">Expense (Normal Debit Balance)</option>
          </Select>
        </div>

        <div>
          <Label htmlFor="parentAccountId">Parent Account (Optional)</Label>
          <Select
            id="parentAccountId"
            value={watch('parentAccountId') ?? ''}
            onChange={(e) =>
              setValue(
                'parentAccountId',
                e.target.value ? Number(e.target.value) : null
              )
            }
          >
            <option value="">(None — Top-level root account)</option>
            {parentCandidates.map((p) => (
              <option key={p.id} value={p.id}>
                {p.accountCode} — {p.accountName}
              </option>
            ))}
          </Select>
          <p className="text-[11px] text-paper-muted mt-1">
            Child accounts inherit classification from their parent (
            {selectedType.toLowerCase()}).
          </p>
        </div>

        <div className="flex justify-end gap-2 pt-3 border-t border-paper-border">
          <Button
            type="button"
            variant="secondary"
            onClick={onClose}
            disabled={createMutation.isPending}
          >
            Cancel
          </Button>
          <Button
            type="submit"
            variant="primary"
            isLoading={createMutation.isPending}
          >
            {isEdit ? 'Save Changes' : 'Create Account'}
          </Button>
        </div>
      </form>
    </Dialog>
  );
};
