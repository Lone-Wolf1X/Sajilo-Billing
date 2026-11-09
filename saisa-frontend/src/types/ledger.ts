export interface MoneyValue {
  amount: number | string;
  currency: string;
}

export interface LedgerEntry {
  entryDate: string; // YYYY-MM-DD
  entryNumber: string;
  journalEntryId: number;
  narration?: string;
  debit: MoneyValue;
  credit: MoneyValue;
  runningBalance: MoneyValue;
}

export interface LedgerStatement {
  accountId: number;
  accountCode: string;
  accountName: string;
  fromDate: string;
  toDate: string;
  entries: LedgerEntry[];
}

