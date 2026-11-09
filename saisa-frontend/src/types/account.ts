export type AccountType =
  | 'ASSET'
  | 'EXPENSE'
  | 'LIABILITY'
  | 'EQUITY'
  | 'INCOME';

export interface ChartOfAccount {
  id: number;
  accountCode: string;
  accountName: string;
  accountType: AccountType;
  parentAccountId: number | null;
  systemAccount: boolean;
  active: boolean;
}

export interface CreateAccountRequest {
  accountCode: string;
  accountName: string;
  accountType: AccountType;
  parentAccountId?: number | null;
}

