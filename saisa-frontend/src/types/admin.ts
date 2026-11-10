export interface TenantSummary {
  id: number;
  tenantCode: string;
  companyName: string;
  companyNameNepali?: string;
  panVatNo?: string;
  email?: string;
  phone?: string;
  status: string;
  setupCompleted: boolean;
  createdAt: string;
  userCount: number;
  invoiceCount: number;
}

export interface OnboardTenantPayload {
  companyName: string;
  companyNameNepali?: string;
  tenantCode: string;
  panVatNo?: string;
  phone?: string;
  email?: string;
  province?: string;
  district?: string;
  address?: string;
  adminUsername: string;
  adminEmail: string;
  adminPassword: string;
  adminFullName: string;
}

export interface EmailSettings {
  id?: number;
  smtpHost: string;
  smtpPort: number;
  smtpUsername: string;
  smtpPassword?: string;
  fromEmail: string;
  fromName: string;
  starttlsEnabled: boolean;
  authEnabled: boolean;
  updatedAt?: string;
}
