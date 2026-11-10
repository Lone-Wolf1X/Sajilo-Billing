import { apiClient } from '../lib/axios';
import { useAuthStore } from '../stores/authStore';
import type { LoginRequest, RegisterTenantRequest, AuthResponse } from '../types/auth';

export const authService = {
  async login(credentials: LoginRequest): Promise<AuthResponse> {
    const response = await apiClient.post<AuthResponse>('/api/v1/auth/login', credentials);
    useAuthStore.getState().setAuth(response.data);
    return response.data;
  },

  async register(data: RegisterTenantRequest): Promise<AuthResponse> {
    const response = await apiClient.post<AuthResponse>('/api/v1/auth/register', data);
    useAuthStore.getState().setAuth(response.data);
    return response.data;
  },

  async refresh(refreshToken: string): Promise<AuthResponse> {
    const response = await apiClient.post<AuthResponse>('/api/v1/auth/refresh', { refreshToken });
    const { accessToken, refreshToken: newRefreshToken } = response.data;
    useAuthStore.getState().setTokens(accessToken, newRefreshToken);
    return response.data;
  },

  async forgotPassword(data: { email: string; tenantCode?: string }): Promise<{ success: boolean; message: string; email: string }> {
    const response = await apiClient.post<{ success: boolean; message: string; email: string }>('/api/v1/auth/forgot-password', data);
    return response.data;
  },

  async resetPasswordWithOtp(data: { email: string; otp: string; newPassword: string }): Promise<{ success: boolean; message: string }> {
    const response = await apiClient.post<{ success: boolean; message: string }>('/api/v1/auth/reset-password-otp', data);
    return response.data;
  },

  logout(): void {
    useAuthStore.getState().logout();
  },
};

