import apiClient from '../lib/axios';
import type {
  CompanyProfile,
  UpdateProfileRequest,
  SetupStatus,
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
};
