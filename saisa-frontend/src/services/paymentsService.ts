import apiClient from '../lib/axios';
import type {
  Payment,
  CreatePaymentRequest,
  PaymentListParams,
} from '../types/payment';

export const paymentsService = {
  async list(params?: PaymentListParams): Promise<Payment[]> {
    const res = await apiClient.get<Payment[]>('/api/v1/payments', { params });
    return res.data;
  },

  async getById(id: number): Promise<Payment> {
    const res = await apiClient.get<Payment>(`/api/v1/payments/${id}`);
    return res.data;
  },

  async create(payload: CreatePaymentRequest): Promise<Payment> {
    const res = await apiClient.post<Payment>('/api/v1/payments', payload);
    return res.data;
  },
};

