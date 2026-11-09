import apiClient from '../lib/axios';
import type { Vendor, CreateVendorRequest } from '../types/vendor';

export const vendorsService = {
  async list(): Promise<Vendor[]> {
    const res = await apiClient.get<Vendor[]>('/api/v1/vendors');
    return res.data;
  },

  async getById(id: number): Promise<Vendor> {
    const res = await apiClient.get<Vendor>(`/api/v1/vendors/${id}`);
    return res.data;
  },

  async create(data: CreateVendorRequest): Promise<Vendor> {
    const res = await apiClient.post<Vendor>('/api/v1/vendors', data);
    return res.data;
  },
};
