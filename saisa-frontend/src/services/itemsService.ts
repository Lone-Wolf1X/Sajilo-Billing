import apiClient from '../lib/axios';
import type { Item } from '../types/item';

export const itemsService = {
  async list(): Promise<Item[]> {
    const res = await apiClient.get<Item[]>('/api/v1/items');
    return res.data;
  },

  async getById(id: number): Promise<Item> {
    const res = await apiClient.get<Item>(`/api/v1/items/${id}`);
    return res.data;
  },
};
