import apiClient from '../lib/axios';
import type {
  PurchaseInvoice,
  CreatePurchaseInvoiceRequest,
  PurchaseInvoiceListParams,
} from '../types/purchaseInvoice';

export const purchaseInvoicesService = {
  async list(params?: PurchaseInvoiceListParams): Promise<PurchaseInvoice[]> {
    const res = await apiClient.get<PurchaseInvoice[]>('/api/v1/purchase-invoices', {
      params,
    });
    return res.data;
  },

  async getById(id: number): Promise<PurchaseInvoice> {
    const res = await apiClient.get<PurchaseInvoice>(`/api/v1/purchase-invoices/${id}`);
    return res.data;
  },

  async create(data: CreatePurchaseInvoiceRequest): Promise<PurchaseInvoice> {
    const res = await apiClient.post<PurchaseInvoice>('/api/v1/purchase-invoices', data);
    return res.data;
  },
};
