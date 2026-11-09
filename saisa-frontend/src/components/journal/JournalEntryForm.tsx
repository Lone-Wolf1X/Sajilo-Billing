import React, { useEffect, useMemo } from 'react';
import { useForm, useWatch } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import { Input } from '../ui/input';
import { Label } from '../ui/label';
import { Select } from '../ui/select';
import { Button } from '../ui/button';
import { JournalLinesTable, type LineForm } from './JournalLinesTable';
import { JournalBalanceIndicator } from './JournalBalanceIndicator';
import {
  useCreateJournalEntry,
  usePostJournalEntry,
} from '../../hooks/useJournalEntries';
import { usePeriods } from '../../hooks/usePeriods';
import type { EntryType } from '../../types/journalEntry';

const lineSchema = z.object({
  accountId: z.number().int().positive('Account required').nullable(),
  side: z.enum(['DEBIT', 'CREDIT']),
  amount: z.string(),
  description: z.string().optional(),
});

const formSchema = z.object({
  entryDate: z.string().min(1, 'Entry date is required'),
  periodId: z.number().int().positive('Accounting period is required'),
  entryType: z.enum([
    'MANUAL',
    'JOURNAL',
    'CONTRA',
    'ADJUSTMENT',
    'OPENING',
    'SALES',
    'PURCHASE',
    'RECEIPT',
    'PAYMENT',
    'CLOSING',
    'REVERSAL',
  ]),
  description: z
    .string()
    .min(1, 'Voucher narration is required')
    .max(500, 'Narration cannot exceed 500 characters'),
  lines: z.array(lineSchema).min(2, 'At least 2 lines required'),
});

type FormData = z.infer<typeof formSchema>;

export const JournalEntryForm: React.FC = () => {
  const navigate = useNavigate();
  const { periods = [] } = usePeriods();
  const createMutation = useCreateJournalEntry();
  const postMutation = usePostJournalEntry();

  const defaultPeriodId = useMemo(() => {
    const today = new Date().toISOString().slice(0, 10);
    const active = periods.find(
      (p) => p.status === 'OPEN' && p.startDate <= today && today <= p.endDate
    );
    return active?.id ?? (periods.find((p) => p.status === 'OPEN')?.id ?? 0);
  }, [periods]);

  const {
    control,
    register,
    handleSubmit,
    setValue,
    watch,
    reset,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      entryDate: new Date().toISOString().slice(0, 10),
      periodId: 0,
      entryType: 'MANUAL',
      description: '',
      lines: [
        { accountId: null, side: 'DEBIT', amount: '', description: '' },
        { accountId: null, side: 'CREDIT', amount: '', description: '' },
      ],
    },
  });

  const periodIdValue = watch('periodId');

  useEffect(() => {
    if (defaultPeriodId > 0 && periodIdValue === 0) {
      setValue('periodId', defaultPeriodId, { shouldValidate: true });
    }
  }, [defaultPeriodId, periodIdValue, setValue]);

  const lines = useWatch({ control, name: 'lines' }) as LineForm[] | undefined;

  const { totalDebit, totalCredit, isBalanced, hasLines } = useMemo(() => {
    let dr = 0;
    let cr = 0;
    let count = 0;

    for (const line of lines ?? []) {
      const amt = parseFloat(line.amount) || 0;
      if (amt > 0 && line.accountId) {
        count++;
      }
      if (line.side === 'DEBIT') {
        dr += amt;
      } else {
        cr += amt;
      }
    }

    return {
      totalDebit: dr.toFixed(2),
      totalCredit: cr.toFixed(2),
      isBalanced: dr > 0 && Math.abs(dr - cr) < 0.0001,
      hasLines: count > 0,
    };
  }, [lines]);

  const onSubmit = async (data: FormData) => {
    if (!isBalanced) {
      toast.error('Cannot post unbalanced entry. Debits must equal Credits.');
      return;
    }

    // Filter out uncompleted rows
    const validLines = data.lines.filter(
      (l) => l.accountId && parseFloat(l.amount) > 0
    );

    if (validLines.length < 2) {
      toast.error('Double-entry voucher requires at least 2 valid lines.');
      return;
    }

    try {
      const payload = {
        entryDate: data.entryDate,
        periodId: data.periodId,
        entryType: data.entryType as EntryType,
        description: data.description,
        lines: validLines.map((l) => ({
          accountId: l.accountId!,
          side: l.side,
          amount: l.amount,
          description: l.description,
        })),
      };

      // Step 1: Create draft
      const draft = await createMutation.mutateAsync(payload);

      // Step 2: Post immediately to General Ledger
      await postMutation.mutateAsync(draft.id);

      toast.success(`Journal Voucher ${draft.entryNumber} successfully posted!`);
      navigate(`/journal-entries/${draft.id}`);
    } catch (err: any) {
      const msg =
        err?.response?.data?.message || err?.message || 'Posting failed.';
      toast.error(msg);
    }
  };

  const isSubmitting = createMutation.isPending || postMutation.isPending;

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
      {/* Voucher Header Metadata */}
      <div className="bg-paper-surface border border-paper-border rounded-lg p-5 shadow-subtle">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div>
            <Label htmlFor="entryDate" required>
              Posting Date
            </Label>
            <Input
              id="entryDate"
              type="date"
              {...register('entryDate')}
              error={errors.entryDate?.message}
            />
          </div>

          <div>
            <Label htmlFor="periodId" required>
              Accounting Period
            </Label>
            <Select
              id="periodId"
              {...register('periodId', { valueAsNumber: true })}
              error={errors.periodId?.message}
            >
              <option value={0}>Select open period...</option>
              {periods
                .filter((p) => p.status === 'OPEN')
                .map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.periodName} (
                    {p.startDate} to {p.endDate})
                  </option>
                ))}
            </Select>
          </div>

          <div>
            <Label htmlFor="entryType" required>
              Voucher Type
            </Label>
            <Select id="entryType" {...register('entryType')}>
              <option value="MANUAL">Manual Journal Voucher [F7]</option>
              <option value="JOURNAL">Standard Journal Entry</option>
              <option value="CONTRA">Contra Entry (Cash/Bank) [F4]</option>
              <option value="ADJUSTMENT">Period Adjustment</option>
              <option value="OPENING">Opening Balance</option>
            </Select>
          </div>

          <div className="flex flex-col justify-end">
            <span className="text-[11px] text-paper-muted">
              Accounting Standard:
            </span>
            <span className="text-xs font-semibold text-brand-navy">
              Double-Entry General Ledger (INR/NPR)
            </span>
          </div>
        </div>

        <div className="mt-4">
          <Label htmlFor="description" required>
            Voucher Narration / Memo
          </Label>
          <Input
            id="description"
            {...register('description')}
            placeholder="e.g. Paid office rent for November 2026 via HDFC bank transfer"
            maxLength={500}
            error={errors.description?.message}
          />
        </div>
      </div>

      {/* Multi-Line Ledger Grid */}
      <div className="bg-paper-surface border border-paper-border rounded-lg p-5 shadow-subtle">
        <div className="flex items-center justify-between mb-3">
          <h2 className="font-serif font-bold text-base text-brand-navy">
            Voucher Debit & Credit Lines
          </h2>
          <span className="text-xs text-paper-muted">
            Tab key to navigate between accounts and debit/credit amounts
          </span>
        </div>

        <JournalLinesTable
          control={control}
          register={register}
          setValue={setValue}
        />
      </div>

      {/* Sticky Bottom Actions & Equilibrium Status */}
      <div className="sticky bottom-4 z-20 bg-paper-surface border border-paper-border-strong rounded-lg p-4 flex flex-col sm:flex-row items-center justify-between gap-3 shadow-lg">
        <JournalBalanceIndicator
          totalDebit={totalDebit}
          totalCredit={totalCredit}
          isBalanced={isBalanced}
          hasLines={hasLines}
        />

        <div className="flex items-center gap-2 w-full sm:w-auto justify-end">
          <Button
            type="button"
            variant="secondary"
            onClick={() =>
              reset({
                entryDate: new Date().toISOString().slice(0, 10),
                periodId: defaultPeriodId,
                entryType: 'MANUAL',
                description: '',
                lines: [
                  { accountId: null, side: 'DEBIT', amount: '', description: '' },
                  { accountId: null, side: 'CREDIT', amount: '', description: '' },
                ],
              })
            }
            disabled={isSubmitting}
          >
            Clear Form
          </Button>

          <Button
            type="submit"
            variant="primary"
            disabled={!isBalanced || isSubmitting}
            isLoading={isSubmitting}
            className="cursor-pointer"
          >
            {isSubmitting ? 'Posting Voucher...' : 'Post Journal Voucher [F7]'}
          </Button>
        </div>
      </div>
    </form>
  );
};

