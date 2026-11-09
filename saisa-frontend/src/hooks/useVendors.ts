import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { vendorsService } from '../services/vendorsService';
import type { CreateVendorRequest } from '../types/vendor';
import { toast } from 'sonner';

export const VENDORS_QUERY_KEY = ['vendors'];

export function useVendors() {
  const queryClient = useQueryClient();

  const vendorsQuery = useQuery({
    queryKey: VENDORS_QUERY_KEY,
    queryFn: () => vendorsService.list(),
  });

  const createMutation = useMutation({
    mutationFn: (data: CreateVendorRequest) => vendorsService.create(data),
    onSuccess: (newVen) => {
      queryClient.invalidateQueries({ queryKey: VENDORS_QUERY_KEY });
      toast.success(`Vendor "${newVen.vendorName}" added successfully.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to create vendor.';
      toast.error(msg);
    },
  });

  return {
    vendors: vendorsQuery.data || [],
    isLoading: vendorsQuery.isLoading,
    isError: vendorsQuery.isError,
    error: vendorsQuery.error,
    refetch: vendorsQuery.refetch,
    createVendor: createMutation.mutateAsync,
    isCreating: createMutation.isPending,
  };
}

export function useCreateVendor() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: CreateVendorRequest) => vendorsService.create(data),
    onSuccess: (newVen) => {
      queryClient.invalidateQueries({ queryKey: VENDORS_QUERY_KEY });
      toast.success(`Vendor "${newVen.vendorName}" added successfully.`);
    },
    onError: (err: any) => {
      const msg =
        err.response?.data?.message || err.message || 'Failed to create vendor.';
      toast.error(msg);
    },
  });
}

export function useVendor(id?: number) {
  return useQuery({
    queryKey: [...VENDORS_QUERY_KEY, id],
    queryFn: () => vendorsService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}
