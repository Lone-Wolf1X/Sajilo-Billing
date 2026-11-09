import apiClient from '../lib/axios';
import type { Customer, CreateCustomerRequest } from '../types/customer';

export const customersService = {
  async list(): Promise<Customer[]> {
    const res = await apiClient.get<Customer[]>('/api/v1/customers');
    return res.data;
  },

  async getById(id: number): Promise<Customer> {
    const res = await apiClient.get<Customer>(`/api/v1/customers/${id}`);
    return res.data;
  },

  async create(data: CreateCustomerRequest): Promise<Customer> {
    const res = await apiClient.post<Customer>('/api/v1/customers', data);
    return res.data;
  },
};
