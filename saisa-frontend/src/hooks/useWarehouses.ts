import { useQuery } from '@tanstack/react-query';
import { warehousesService } from '../services/warehousesService';

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
