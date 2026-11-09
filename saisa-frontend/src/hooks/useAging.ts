import { useQuery } from '@tanstack/react-query';
import { agingService } from '../services/agingService';

export function useArAging(asOf?: string, enabled = true) {
  return useQuery({
    queryKey: ['ar-aging', asOf],
    queryFn: () => agingService.arAging(asOf),
    staleTime: 60_000,
    enabled,
  });
}

export function useApAging(asOf?: string, enabled = true) {
  return useQuery({
    queryKey: ['ap-aging', asOf],
    queryFn: () => agingService.apAging(asOf),
    staleTime: 60_000,
    enabled,
  });
}

