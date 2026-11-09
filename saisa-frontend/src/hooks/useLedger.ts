import { useQuery } from '@tanstack/react-query';
import { ledgerService } from '../services/ledgerService';

export function useLedger(accountId?: number, from?: string, to?: string) {
  return useQuery({
    queryKey: ['ledger', accountId, from, to],
    queryFn: () => ledgerService.getStatement(accountId!, from!, to!),
    enabled: typeof accountId === 'number' && accountId > 0 && Boolean(from) && Boolean(to),
  });
}
