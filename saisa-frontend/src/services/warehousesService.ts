import apiClient from '../lib/axios';
import type { Warehouse, CreateWarehouseRequest } from '../types/warehouse';

export const warehousesService = {
  async list(): Promise<Warehouse[]> {
    const res = await apiClient.get<Warehouse[]>('/api/v1/warehouses');
    return res.data;
  },

  async create(data: CreateWarehouseRequest): Promise<Warehouse> {
    const res = await apiClient.post<Warehouse>('/api/v1/warehouses', data);
    return res.data;
  },
};
