import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { purchaseInvoicesService } from '../services/purchaseInvoicesService';
import type {
  CreatePurchaseInvoiceRequest,
  PurchaseInvoiceListParams,
} from '../types/purchaseInvoice';
import { toast } from 'sonner';

export const PURCHASE_INVOICES_QUERY_KEY = ['purchase-invoices'];

export function usePurchaseInvoices(params?: PurchaseInvoiceListParams) {
  const invoicesQuery = useQuery({
    queryKey: [...PURCHASE_INVOICES_QUERY_KEY, params],
    queryFn: () => purchaseInvoicesService.list(params),
  });

  return {
    invoices: invoicesQuery.data || [],
    isLoading: invoicesQuery.isLoading,
    isError: invoicesQuery.isError,
    error: invoicesQuery.error,
    refetch: invoicesQuery.refetch,
  };
}

export function usePurchaseInvoice(id?: number) {
  return useQuery({
    queryKey: [...PURCHASE_INVOICES_QUERY_KEY, id],
    queryFn: () => purchaseInvoicesService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}

export function useCreatePurchaseInvoice() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreatePurchaseInvoiceRequest) =>
      purchaseInvoicesService.create(data),
    onSuccess: (newInv) => {
      queryClient.invalidateQueries({ queryKey: PURCHASE_INVOICES_QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: ['journal-entries'] });
      queryClient.invalidateQueries({ queryKey: ['ledger'] });
      toast.success(`Purchase invoice "${newInv.invoiceNumber}" created and posted successfully.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message ||
        err.message ||
        'Failed to create purchase invoice.';
      toast.error(msg);
    },
  });
}
