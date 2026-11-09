import apiClient from '../lib/axios';
import type {
  CompanyProfile,
  UpdateProfileRequest,
  SetupStatus,
  OpeningBalanceRequest,
  OpeningBalanceResponse,
  OpeningStockRequest,
  OpeningStockResponse,
} from '../types/setup';

export const setupService = {
  async getProfile(): Promise<CompanyProfile> {
    const res = await apiClient.get<CompanyProfile>('/api/v1/setup/profile');
    return res.data;
  },

  async updateProfile(payload: UpdateProfileRequest): Promise<CompanyProfile> {
    const res = await apiClient.put<CompanyProfile>(
      '/api/v1/setup/profile',
      payload
    );
    return res.data;
  },

  async getStatus(): Promise<SetupStatus> {
    const res = await apiClient.get<SetupStatus>('/api/v1/setup/status');
    return res.data;
  },

  async completeSetup(): Promise<SetupStatus> {
    const res = await apiClient.post<SetupStatus>('/api/v1/setup/complete');
    return res.data;
  },

  async getLocations(): Promise<any> {
    const res = await apiClient.get<any>('/api/v1/setup/locations');
    return res.data;
  },

  async getRegistrationAuthorities(): Promise<
    Record<string, { en: string; np: string }>
  > {
    const res = await apiClient.get<
      Record<string, { en: string; np: string }>
    >('/api/v1/setup/registration-authorities');
    return res.data;
  },

  async getOpeningBalance(): Promise<OpeningBalanceResponse> {
    const res = await apiClient.get<OpeningBalanceResponse>('/api/v1/setup/opening-balances');
    return res.data;
  },

  async postOpeningBalance(payload: OpeningBalanceRequest): Promise<OpeningBalanceResponse> {
    const res = await apiClient.post<OpeningBalanceResponse>('/api/v1/setup/opening-balances', payload);
    return res.data;
  },

  async resetOpeningBalance(reason: string): Promise<void> {
    await apiClient.delete('/api/v1/setup/opening-balances', {
      params: { reason },
    });
  },

  async getOpeningStock(): Promise<OpeningStockResponse> {
    const res = await apiClient.get<OpeningStockResponse>('/api/v1/setup/opening-stock');
    return res.data;
  },

  async postOpeningStock(payload: OpeningStockRequest): Promise<OpeningStockResponse> {
    const res = await apiClient.post<OpeningStockResponse>('/api/v1/setup/opening-stock', payload);
    return res.data;
  },
};
