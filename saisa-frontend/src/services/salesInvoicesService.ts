import apiClient from '../lib/axios';
import type {
  SalesInvoice,
  CreateSalesInvoiceRequest,
  SalesInvoiceListParams,
} from '../types/salesInvoice';

export const salesInvoicesService = {
  async list(params?: SalesInvoiceListParams): Promise<SalesInvoice[]> {
    const res = await apiClient.get<SalesInvoice[]>('/api/v1/sales-invoices', {
      params,
    });
    return res.data;
  },

  async getById(id: number): Promise<SalesInvoice> {
    const res = await apiClient.get<SalesInvoice>(`/api/v1/sales-invoices/${id}`);
    return res.data;
  },

  async create(data: CreateSalesInvoiceRequest): Promise<SalesInvoice> {
    const res = await apiClient.post<SalesInvoice>('/api/v1/sales-invoices', data);
    return res.data;
  },
};
