import apiClient from '../lib/axios';
import type {
  BankAccount,
  CreateBankAccountRequest,
} from '../types/bankAccount';

export const bankAccountsService = {
  async list(): Promise<BankAccount[]> {
    const res = await apiClient.get<BankAccount[]>('/api/v1/bank-accounts');
    return res.data;
  },

  async create(payload: CreateBankAccountRequest): Promise<BankAccount> {
    const res = await apiClient.post<BankAccount>(
      '/api/v1/bank-accounts',
      payload
    );
    return res.data;
  },
};

