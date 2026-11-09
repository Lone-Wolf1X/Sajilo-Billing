import { useQuery } from '@tanstack/react-query';
import { itemsService } from '../services/itemsService';

export const ITEMS_QUERY_KEY = ['items'];

export function useItems() {
  const itemsQuery = useQuery({
    queryKey: ITEMS_QUERY_KEY,
    queryFn: () => itemsService.list(),
  });

  return {
    items: itemsQuery.data || [],
    isLoading: itemsQuery.isLoading,
    isError: itemsQuery.isError,
    error: itemsQuery.error,
    refetch: itemsQuery.refetch,
  };
}

export function useItem(id?: number) {
  return useQuery({
    queryKey: [...ITEMS_QUERY_KEY, id],
    queryFn: () => itemsService.getById(id!),
    enabled: typeof id === 'number' && id > 0,
  });
}
