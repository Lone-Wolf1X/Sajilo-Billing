import apiClient from '../lib/axios';
import type {
  CreditNote,
  CreateCreditNoteRequest,
  CreditNoteListParams,
} from '../types/creditNote';

export const creditNotesService = {
  async list(params: CreditNoteListParams = {}): Promise<CreditNote[]> {
    const { data } = await apiClient.get<CreditNote[]>('/api/v1/credit-notes', { params });
    return data;
  },
  async getById(id: number): Promise<CreditNote> {
    const { data } = await apiClient.get<CreditNote>(`/api/v1/credit-notes/${id}`);
    return data;
  },
  async create(payload: CreateCreditNoteRequest): Promise<CreditNote> {
    const { data } = await apiClient.post<CreditNote>('/api/v1/credit-notes', payload);
    return data;
  },
};
