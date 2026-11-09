import apiClient from '../lib/axios';
import type {
  JournalEntry,
  CreateJournalEntryRequest,
  ReverseJournalEntryRequest,
} from '../types/journalEntry';

export const journalEntriesService = {
  async getById(id: number): Promise<JournalEntry> {
    const res = await apiClient.get<JournalEntry>(`/api/v1/journal-entries/${id}`);
    return res.data;
  },

  async create(data: CreateJournalEntryRequest): Promise<JournalEntry> {
    const res = await apiClient.post<JournalEntry>('/api/v1/journal-entries', data);
    return res.data;
  },

  async post(id: number): Promise<JournalEntry> {
    const res = await apiClient.post<JournalEntry>(
      `/api/v1/journal-entries/${id}/post`
    );
    return res.data;
  },

  async reverse(
    id: number,
    data: ReverseJournalEntryRequest
  ): Promise<JournalEntry> {
    const res = await apiClient.post<JournalEntry>(
      `/api/v1/journal-entries/${id}/reverse`,
      data
    );
    return res.data;
  },
};
