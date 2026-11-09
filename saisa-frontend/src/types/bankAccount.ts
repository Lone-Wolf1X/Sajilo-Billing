export interface BankAccount {
  id: number;
  accountCode: string;
  accountName: string;
  bankName: string | null;
  accountNumber: string | null;
  ifscCode: string | null;
  glAccountId: number;
  defaultAccount: boolean;
  active: boolean;
}

export interface CreateBankAccountRequest {
  accountCode: string;
  accountName: string;
  bankName?: string;
  accountNumber?: string;
  ifscCode?: string;
  glAccountId: number;
  defaultAccount?: boolean;
}

