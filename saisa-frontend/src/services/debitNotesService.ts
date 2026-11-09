import apiClient from '../lib/axios';
import type {
  DebitNote,
  CreateDebitNoteRequest,
  DebitNoteListParams,
} from '../types/debitNote';

export const debitNotesService = {
  async list(params: DebitNoteListParams = {}): Promise<DebitNote[]> {
    const { data } = await apiClient.get<DebitNote[]>('/api/v1/debit-notes', { params });
    return data;
  },
  async getById(id: number): Promise<DebitNote> {
    const { data } = await apiClient.get<DebitNote>(`/api/v1/debit-notes/${id}`);
    return data;
  },
  async create(payload: CreateDebitNoteRequest): Promise<DebitNote> {
    const { data } = await apiClient.post<DebitNote>('/api/v1/debit-notes', payload);
    return data;
  },
};
