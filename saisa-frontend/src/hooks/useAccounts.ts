import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { accountsService } from '../services/accountsService';
import type { CreateAccountRequest } from '../types/account';
import { toast } from 'sonner';

export const ACCOUNTS_QUERY_KEY = ['accounts'];

export function useAccounts() {
  const queryClient = useQueryClient();

  const accountsQuery = useQuery({
    queryKey: ACCOUNTS_QUERY_KEY,
    queryFn: () => accountsService.list(),
  });

  const createMutation = useMutation({
    mutationFn: (data: CreateAccountRequest) => accountsService.create(data),
    onSuccess: (newAccount) => {
      queryClient.invalidateQueries({ queryKey: ACCOUNTS_QUERY_KEY });
      toast.success(
        `Account "${newAccount.accountCode} — ${newAccount.accountName}" created successfully.`
      );
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to create account.';
      toast.error(msg);
    },
  });

  return {
    accounts: accountsQuery.data || [],
    isLoading: accountsQuery.isLoading,
    isError: accountsQuery.isError,
    error: accountsQuery.error,
    refetch: accountsQuery.refetch,
    createAccount: createMutation.mutateAsync,
    isCreating: createMutation.isPending,
  };
}

export function useCreateAccount() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: CreateAccountRequest) => accountsService.create(data),
    onSuccess: (newAccount) => {
      queryClient.invalidateQueries({ queryKey: ACCOUNTS_QUERY_KEY });
      toast.success(
        `Account "${newAccount.accountCode} — ${newAccount.accountName}" created successfully.`
      );
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to create account.';
      toast.error(msg);
    },
  });
}

export function useAccount(id?: number) {
  return useQuery({
    queryKey: [...ACCOUNTS_QUERY_KEY, id],
    queryFn: () => accountsService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}
