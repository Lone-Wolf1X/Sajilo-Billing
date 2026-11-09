import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { customersService } from '../services/customersService';
import type { CreateCustomerRequest } from '../types/customer';
import { toast } from 'sonner';

export const CUSTOMERS_QUERY_KEY = ['customers'];

export function useCustomers() {
  const queryClient = useQueryClient();

  const customersQuery = useQuery({
    queryKey: CUSTOMERS_QUERY_KEY,
    queryFn: () => customersService.list(),
  });

  const createMutation = useMutation({
    mutationFn: (data: CreateCustomerRequest) => customersService.create(data),
    onSuccess: (newCust) => {
      queryClient.invalidateQueries({ queryKey: CUSTOMERS_QUERY_KEY });
      toast.success(`Customer "${newCust.customerName}" added successfully.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to create customer.';
      toast.error(msg);
    },
  });

  return {
    customers: customersQuery.data || [],
    isLoading: customersQuery.isLoading,
    isError: customersQuery.isError,
    error: customersQuery.error,
    refetch: customersQuery.refetch,
    createCustomer: createMutation.mutateAsync,
    isCreating: createMutation.isPending,
  };
}

export function useCreateCustomer() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: CreateCustomerRequest) => customersService.create(data),
    onSuccess: (newCust) => {
      queryClient.invalidateQueries({ queryKey: CUSTOMERS_QUERY_KEY });
      toast.success(`Customer "${newCust.customerName}" added successfully.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to create customer.';
      toast.error(msg);
    },
  });
}

export function useCustomer(id?: number) {
  return useQuery({
    queryKey: [...CUSTOMERS_QUERY_KEY, id],
    queryFn: () => customersService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}
