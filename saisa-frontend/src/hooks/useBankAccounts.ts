import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { bankAccountsService } from '../services/bankAccountsService';
import type { CreateBankAccountRequest } from '../types/bankAccount';

export const BANK_ACCOUNTS_QUERY_KEY = ['bank-accounts'];

export function useBankAccounts() {
  const query = useQuery({
    queryKey: BANK_ACCOUNTS_QUERY_KEY,
    queryFn: () => bankAccountsService.list(),
    staleTime: 5 * 60_000,
  });

  return {
    bankAccounts: query.data || [],
    isLoading: query.isLoading,
    isError: query.isError,
    error: query.error,
    refetch: query.refetch,
  };
}

export function useCreateBankAccount() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (payload: CreateBankAccountRequest) =>
      bankAccountsService.create(payload),
    onSuccess: (ba) => {
      queryClient.invalidateQueries({ queryKey: BANK_ACCOUNTS_QUERY_KEY });
      toast.success(`Bank account "${ba.accountName}" added successfully.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to add bank account.';
      toast.error(msg);
    },
  });
}

