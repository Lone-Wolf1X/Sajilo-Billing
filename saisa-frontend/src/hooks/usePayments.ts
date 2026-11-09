import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { paymentsService } from '../services/paymentsService';
import type { CreatePaymentRequest, PaymentListParams } from '../types/payment';

export const PAYMENTS_QUERY_KEY = ['payments'];

export function usePayments(params: PaymentListParams = {}) {
  const query = useQuery({
    queryKey: [...PAYMENTS_QUERY_KEY, params],
    queryFn: () => paymentsService.list(params),
    staleTime: 30_000,
  });

  return {
    payments: query.data || [],
    isLoading: query.isLoading,
    isError: query.isError,
    error: query.error,
    refetch: query.refetch,
  };
}

export function usePayment(id?: number) {
  return useQuery({
    queryKey: [...PAYMENTS_QUERY_KEY, id],
    queryFn: () => paymentsService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}

export function useCreatePayment() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (payload: CreatePaymentRequest) =>
      paymentsService.create(payload),
    onSuccess: (p) => {
      queryClient.invalidateQueries({ queryKey: PAYMENTS_QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: ['sales-invoices'] });
      queryClient.invalidateQueries({ queryKey: ['purchase-invoices'] });
      queryClient.invalidateQueries({ queryKey: ['ar-aging'] });
      queryClient.invalidateQueries({ queryKey: ['ap-aging'] });
      queryClient.invalidateQueries({ queryKey: ['accounts'] });
      queryClient.invalidateQueries({ queryKey: ['journal-entries'] });
      queryClient.invalidateQueries({ queryKey: ['ledger'] });
      toast.success(
        `${p.partyType === 'CUSTOMER' ? 'Receipt' : 'Payment'} "${p.paymentNumber}" recorded and posted to ledger!`
      );
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to record payment.';
      toast.error(msg);
    },
  });
}

