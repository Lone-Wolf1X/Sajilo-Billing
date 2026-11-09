import apiClient from '../lib/axios';
import type { AgingReport } from '../types/aging';

export const agingService = {
  async arAging(asOf?: string): Promise<AgingReport> {
    const res = await apiClient.get<AgingReport>('/api/v1/reports/ar-aging', {
      params: asOf ? { asOf } : {},
    });
    return res.data;
  },

  async apAging(asOf?: string): Promise<AgingReport> {
    const res = await apiClient.get<AgingReport>('/api/v1/reports/ap-aging', {
      params: asOf ? { asOf } : {},
    });
    return res.data;
  },
};

