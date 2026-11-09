import apiClient from '../lib/axios';
import type { Item, CreateItemRequest, UpdateItemRequest } from '../types/item';

export const itemsService = {
  async list(): Promise<Item[]> {
    const res = await apiClient.get<Item[]>('/api/v1/items');
    return res.data;
  },

  async getById(id: number): Promise<Item> {
    const res = await apiClient.get<Item>(`/api/v1/items/${id}`);
    return res.data;
  },

  async create(payload: CreateItemRequest): Promise<Item> {
    const res = await apiClient.post<Item>('/api/v1/items', payload);
    return res.data;
  },

  async createBulk(items: CreateItemRequest[]): Promise<{ createdCount: number; items: Item[] }> {
    const res = await apiClient.post<{ createdCount: number; items: Item[] }>('/api/v1/items/bulk', { items });
    return res.data;
  },

  async update(id: number, payload: UpdateItemRequest): Promise<Item> {
    const res = await apiClient.put<Item>(`/api/v1/items/${id}`, payload);
    return res.data;
  },
};
