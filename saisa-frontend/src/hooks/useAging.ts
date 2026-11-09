import { useQuery } from '@tanstack/react-query';
import { agingService } from '../services/agingService';

export function useArAging(asOf?: string) {
  return useQuery({
    queryKey: ['ar-aging', asOf],
    queryFn: () => agingService.arAging(asOf),
    staleTime: 60_000,
  });
}

export function useApAging(asOf?: string) {
  return useQuery({
    queryKey: ['ap-aging', asOf],
    queryFn: () => agingService.apAging(asOf),
    staleTime: 60_000,
  });
}
