import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { salesInvoicesService } from '../services/salesInvoicesService';
import type {
  CreateSalesInvoiceRequest,
  SalesInvoiceListParams,
} from '../types/salesInvoice';
import { toast } from 'sonner';

export const SALES_INVOICES_QUERY_KEY = ['sales-invoices'];

export function useSalesInvoices(params?: SalesInvoiceListParams) {
  const invoicesQuery = useQuery({
    queryKey: [...SALES_INVOICES_QUERY_KEY, params],
    queryFn: () => salesInvoicesService.list(params),
  });

  return {
    invoices: invoicesQuery.data || [],
    isLoading: invoicesQuery.isLoading,
    isError: invoicesQuery.isError,
    error: invoicesQuery.error,
    refetch: invoicesQuery.refetch,
  };
}

export function useSalesInvoice(id?: number) {
  return useQuery({
    queryKey: [...SALES_INVOICES_QUERY_KEY, id],
    queryFn: () => salesInvoicesService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}

export function useCreateSalesInvoice() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateSalesInvoiceRequest) =>
      salesInvoicesService.create(data),
    onSuccess: (newInv) => {
      queryClient.invalidateQueries({ queryKey: SALES_INVOICES_QUERY_KEY });
      // Invalidate general ledger and account balances since invoice posts a journal entry
      queryClient.invalidateQueries({ queryKey: ['journal-entries'] });
      queryClient.invalidateQueries({ queryKey: ['ledger'] });
      toast.success(`Sales invoice "${newInv.invoiceNumber}" created and posted successfully.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message ||
        err.message ||
        'Failed to create sales invoice.';
      toast.error(msg);
    },
  });
}
