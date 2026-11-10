import { useQuery } from '@tanstack/react-query';
import { irdService } from '../services/irdService';

export const useD01SalesBook = (fromDate?: string, toDate?: string) => {
  return useQuery({
    queryKey: ['ird', 'd01', fromDate, toDate],
    queryFn: () => irdService.getD01SalesBook(fromDate, toDate),
  });
};

export const useD02PurchaseBook = (fromDate?: string, toDate?: string) => {
  return useQuery({
    queryKey: ['ird', 'd02', fromDate, toDate],
    queryFn: () => irdService.getD02PurchaseBook(fromDate, toDate),
  });
};

export const useIrdSummary = (fromDate?: string, toDate?: string) => {
  return useQuery({
    queryKey: ['ird', 'summary', fromDate, toDate],
    queryFn: () => irdService.getSummary(fromDate, toDate),
  });
};
