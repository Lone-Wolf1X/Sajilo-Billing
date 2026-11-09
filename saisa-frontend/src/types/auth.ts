export interface LoginRequest {
  tenantCode: string;
  username: string;
  password: string;
}

export interface RegisterTenantRequest {
  tenantCode: string;
  companyName: string;
  adminUsername: string;
  adminPassword: string;
  adminEmail: string;
  adminFullName: string;
}

export interface UserPrincipal {
  userId: number;
  tenantId: number;
  tenantCode: string;
  username: string;
  fullName: string;
  email: string;
  roles: string[];
}

export interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  tokenType: string;
  expiresInSeconds: number;
  user: UserPrincipal;
}

export interface RefreshRequest {
  refreshToken: string;
}

