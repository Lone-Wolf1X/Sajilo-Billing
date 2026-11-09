export type IncorporationType =
  | 'PROPRIETORSHIP'
  | 'PARTNERSHIP'
  | 'PRIVATE_LIMITED'
  | 'PUBLIC_LIMITED'
  | 'COOPERATIVE'
  | 'NGO'
  | 'GOVERNMENT'
  | 'OTHER';

export type BusinessNature =
  | 'TRADING'
  | 'MANUFACTURING'
  | 'SERVICE'
  | 'RETAIL'
  | 'WHOLESALE'
  | 'MIXED'
  | 'OTHER';

export interface CompanyProfile {
  id: number;
  tenantCode: string;
  companyName: string;
  companyNameNepali?: string;
  legalName?: string;
  gstin?: string;
  pan?: string;
  panVatNo?: string;
  panVatDate?: string;
  registrationAuthority?: string;
  registrationNo?: string;
  registrationDate?: string;
  province?: string;
  district?: string;
  municipalityVdc?: string;
  wardNo?: number;
  toleStreet?: string;
  address?: string;
  city?: string;
  state?: string;
  country: string;
  pincode?: string;
  phone?: string;
  email?: string;
  incorporationType?: IncorporationType;
  businessNature?: BusinessNature;
  authorizedPersonName?: string;
  authorizedPersonDesignation?: string;
  authorizedPersonPhone?: string;
  authorizedPersonEmail?: string;
  setupCompleted: boolean;
  setupCompletedAt?: string;
  setupStep: number;
}

export interface UpdateProfileRequest {
  companyName: string;
  companyNameNepali?: string;
  legalName?: string;
  panVatNo?: string;
  panVatDate?: string;
  registrationAuthority?: string;
  registrationNo?: string;
  registrationDate?: string;
  province?: string;
  district?: string;
  municipalityVdc?: string;
  wardNo?: number;
  toleStreet?: string;
  address?: string;
  phone?: string;
  email?: string;
  incorporationType?: IncorporationType;
  businessNature?: BusinessNature;
  authorizedPersonName?: string;
  authorizedPersonDesignation?: string;
  authorizedPersonPhone?: string;
  authorizedPersonEmail?: string;
  setupStep?: number;
}

export interface SetupStatus {
  tenantId: number;
  tenantCode: string;
  companyName: string;
  setupCompleted: boolean;
  setupCompletedAt?: string;
  setupStep: number;
}

export interface OpeningBalanceRequest {
  openingDate: string;
  cashInHand?: string;
  bankBalance?: string;
  accountsReceivable?: string;
  fixedAssets?: string;
  investments?: string;
  otherAssets?: string;
  accountsPayable?: string;
  bankLoans?: string;
  otherLiabilities?: string;
  capital?: string;
  retainedEarnings?: string;
}

export interface OpeningBalanceResponse {
  posted: boolean;
  journalEntryId: number | null;
  journalEntryNumber: string | null;
  openingDate: string | null;
  totalDebits: number | string;
  totalCredits: number | string;
  totalAssets: number | string;
  totalLiabilities: number | string;
  totalEquity: number | string;
  balanced: boolean;
}


