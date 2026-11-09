import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { journalEntriesService } from '../services/journalEntriesService';
import type {
  CreateJournalEntryRequest,
  ReverseJournalEntryRequest,
} from '../types/journalEntry';
import { ACCOUNTS_QUERY_KEY } from './useAccounts';
import { toast } from 'sonner';

export const JOURNAL_ENTRIES_QUERY_KEY = ['journal-entries'];

export function useJournalEntry(id?: number) {
  return useQuery({
    queryKey: [...JOURNAL_ENTRIES_QUERY_KEY, id],
    queryFn: () => journalEntriesService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}

export function useJournalMutations() {
  const queryClient = useQueryClient();

  const createMutation = useMutation({
    mutationFn: (data: CreateJournalEntryRequest) =>
      journalEntriesService.create(data),
    onSuccess: (entry) => {
      queryClient.invalidateQueries({ queryKey: JOURNAL_ENTRIES_QUERY_KEY });
      toast.success(`Draft voucher #${entry.entryNumber} created.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to create voucher.';
      toast.error(msg);
    },
  });

  const postMutation = useMutation({
    mutationFn: (id: number) => journalEntriesService.post(id),
    onSuccess: (entry) => {
      queryClient.invalidateQueries({ queryKey: JOURNAL_ENTRIES_QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: ACCOUNTS_QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: ['ledger'] });
      toast.success(
        `Voucher #${entry.entryNumber} posted to General Ledger successfully!`
      );
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to post voucher.';
      toast.error(msg);
    },
  });

  const reverseMutation = useMutation({
    mutationFn: ({
      id,
      data,
    }: {
      id: number;
      data: ReverseJournalEntryRequest;
    }) => journalEntriesService.reverse(id, data),
    onSuccess: (reversal) => {
      queryClient.invalidateQueries({ queryKey: JOURNAL_ENTRIES_QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: ACCOUNTS_QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: ['ledger'] });
      toast.success(`Reversal voucher #${reversal.entryNumber} posted.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to reverse voucher.';
      toast.error(msg);
    },
  });

  return {
    createEntry: createMutation.mutateAsync,
    isCreating: createMutation.isPending,
    postEntry: postMutation.mutateAsync,
    isPosting: postMutation.isPending,
    reverseEntry: reverseMutation.mutateAsync,
    isReversing: reverseMutation.isPending,
  };
}

