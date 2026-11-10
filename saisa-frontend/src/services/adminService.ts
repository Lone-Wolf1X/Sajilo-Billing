import apiClient from '../lib/axios';
import type { TenantSummary, OnboardTenantPayload, EmailSettings } from '../types/admin';

export const adminService = {
  async listTenants(): Promise<TenantSummary[]> {
    const res = await apiClient.get<TenantSummary[]>('/api/v1/admin/tenants');
    return res.data;
  },

  async onboardTenant(payload: OnboardTenantPayload): Promise<TenantSummary> {
    const res = await apiClient.post<TenantSummary>('/api/v1/admin/tenants/onboard', payload);
    return res.data;
  },

  async toggleTenantStatus(id: number, status: string): Promise<TenantSummary> {
    const res = await apiClient.put<TenantSummary>(`/api/v1/admin/tenants/${id}/status`, null, {
      params: { status },
    });
    return res.data;
  },

  async getEmailSettings(): Promise<EmailSettings> {
    const res = await apiClient.get<EmailSettings>('/api/v1/admin/email-settings');
    return res.data;
  },

  async updateEmailSettings(settings: EmailSettings): Promise<EmailSettings> {
    const res = await apiClient.put<EmailSettings>('/api/v1/admin/email-settings', settings);
    return res.data;
  },

  async sendTestEmail(recipient?: string): Promise<{ success: boolean; message: string; recipient: string; timestamp: string }> {
    const res = await apiClient.post<{ success: boolean; message: string; recipient: string; timestamp: string }>(
      '/api/v1/admin/email-settings/test',
      null,
      { params: recipient ? { recipient } : {} }
    );
    return res.data;
  },
};
