import apiClient from '../lib/axios';
import type { ChartOfAccount, CreateAccountRequest } from '../types/account';

export const accountsService = {
  async list(): Promise<ChartOfAccount[]> {
    const res = await apiClient.get<ChartOfAccount[]>('/api/v1/accounts');
    return res.data;
  },

  async getById(id: number): Promise<ChartOfAccount> {
    const res = await apiClient.get<ChartOfAccount>(`/api/v1/accounts/${id}`);
    return res.data;
  },

  async create(data: CreateAccountRequest): Promise<ChartOfAccount> {
    const res = await apiClient.post<ChartOfAccount>('/api/v1/accounts', data);
    return res.data;
  },
};
