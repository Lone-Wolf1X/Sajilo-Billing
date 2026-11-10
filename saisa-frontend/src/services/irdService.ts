import apiClient from '../lib/axios';
import type { D01SalesEntry, D02PurchaseEntry, IrdTaxSummary } from '../types/ird';

export const irdService = {
  async getD01SalesBook(fromDate?: string, toDate?: string): Promise<D01SalesEntry[]> {
    const res = await apiClient.get<D01SalesEntry[]>('/api/v1/reports/ird/d01-sales', {
      params: { fromDate, toDate },
    });
    return res.data;
  },

  async getD02PurchaseBook(fromDate?: string, toDate?: string): Promise<D02PurchaseEntry[]> {
    const res = await apiClient.get<D02PurchaseEntry[]>('/api/v1/reports/ird/d02-purchases', {
      params: { fromDate, toDate },
    });
    return res.data;
  },

  async getSummary(fromDate?: string, toDate?: string): Promise<IrdTaxSummary> {
    const res = await apiClient.get<IrdTaxSummary>('/api/v1/reports/ird/summary', {
      params: { fromDate, toDate },
    });
    return res.data;
  },
};

