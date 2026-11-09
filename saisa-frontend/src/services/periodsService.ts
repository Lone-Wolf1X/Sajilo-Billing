import apiClient from '../lib/axios';
import type { AccountingPeriod, CreatePeriodRequest } from '../types/period';

export const periodsService = {
  async list(): Promise<AccountingPeriod[]> {
    const res = await apiClient.get<AccountingPeriod[]>('/api/v1/periods');
    return res.data;
  },

  async getById(id: number): Promise<AccountingPeriod> {
    const res = await apiClient.get<AccountingPeriod>(`/api/v1/periods/${id}`);
    return res.data;
  },

  async create(data: CreatePeriodRequest): Promise<AccountingPeriod> {
    const res = await apiClient.post<AccountingPeriod>('/api/v1/periods', data);
    return res.data;
  },
};

