import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { periodsService } from '../services/periodsService';
import type { CreatePeriodRequest } from '../types/period';
import { toast } from 'sonner';

export const PERIODS_QUERY_KEY = ['periods'];

export function usePeriods() {
  const queryClient = useQueryClient();

  const periodsQuery = useQuery({
    queryKey: PERIODS_QUERY_KEY,
    queryFn: () => periodsService.list(),
  });

  const createMutation = useMutation({
    mutationFn: (data: CreatePeriodRequest) => periodsService.create(data),
    onSuccess: (newPeriod) => {
      queryClient.invalidateQueries({ queryKey: PERIODS_QUERY_KEY });
      toast.success(`Period "${newPeriod.periodName}" created successfully.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to create period.';
      toast.error(msg);
    },
  });

  return {
    periods: periodsQuery.data || [],
    isLoading: periodsQuery.isLoading,
    isError: periodsQuery.isError,
    error: periodsQuery.error,
    refetch: periodsQuery.refetch,
    createPeriod: createMutation.mutateAsync,
    isCreating: createMutation.isPending,
  };
}

export function usePeriod(id?: number) {
  return useQuery({
    queryKey: [...PERIODS_QUERY_KEY, id],
    queryFn: () => periodsService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}
