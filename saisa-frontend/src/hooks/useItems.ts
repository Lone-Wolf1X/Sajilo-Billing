import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { itemsService } from '../services/itemsService';
import type { CreateItemRequest, UpdateItemRequest } from '../types/item';

export const ITEMS_QUERY_KEY = ['items'];

export function useItems() {
  const itemsQuery = useQuery({
    queryKey: ITEMS_QUERY_KEY,
    queryFn: () => itemsService.list(),
    staleTime: 60_000,
  });

  return {
    items: itemsQuery.data || [],
    data: itemsQuery.data || [],
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

export function useCreateItem() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateItemRequest) => itemsService.create(payload),
    onSuccess: (item) => {
      qc.invalidateQueries({ queryKey: ITEMS_QUERY_KEY });
      toast.success(`Item "${item.name}" created successfully`);
    },
    onError: (err: unknown) => {
      const msg = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg ?? 'Failed to create item');
    },
  });
}

export function useUpdateItem() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: UpdateItemRequest }) =>
      itemsService.update(id, data),
    onSuccess: (item) => {
      qc.invalidateQueries({ queryKey: ITEMS_QUERY_KEY });
      qc.invalidateQueries({ queryKey: [...ITEMS_QUERY_KEY, item.id] });
      toast.success(`Item "${item.name}" updated successfully`);
    },
    onError: (err: unknown) => {
      const msg = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg ?? 'Failed to update item');
    },
  });
}

export function useCreateBulkItems() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (items: CreateItemRequest[]) => itemsService.createBulk(items),
    onSuccess: (resp) => {
      qc.invalidateQueries({ queryKey: ITEMS_QUERY_KEY });
      toast.success(`Successfully created ${resp.createdCount} items`);
    },
    onError: (err: unknown) => {
      const msg = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg ?? 'Failed to create items in bulk');
    },
  });
}
