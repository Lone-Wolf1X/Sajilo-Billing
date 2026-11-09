import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { warehousesService } from '../services/warehousesService';
import type { CreateWarehouseRequest } from '../types/warehouse';

export const WAREHOUSES_QUERY_KEY = ['warehouses'];

export function useWarehouses() {
  const whQuery = useQuery({
    queryKey: WAREHOUSES_QUERY_KEY,
    queryFn: () => warehousesService.list(),
  });

  return {
    warehouses: whQuery.data || [],
    isLoading: whQuery.isLoading,
    isError: whQuery.isError,
    error: whQuery.error,
    refetch: whQuery.refetch,
  };
}

export function useCreateWarehouse() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (data: CreateWarehouseRequest) => warehousesService.create(data),
    onSuccess: (wh) => {
      qc.invalidateQueries({ queryKey: WAREHOUSES_QUERY_KEY });
      toast.success(`Warehouse "${wh.name}" created successfully`);
    },
    onError: (err: unknown) => {
      const msg = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg ?? 'Failed to create warehouse');
    },
  });
}

