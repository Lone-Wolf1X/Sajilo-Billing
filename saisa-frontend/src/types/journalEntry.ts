export type EntryType =
  | 'MANUAL'
  | 'SALES'
  | 'PURCHASE'
  | 'PAYMENT'
  | 'RECEIPT'
  | 'CONTRA'
  | 'INVENTORY'
  | 'CLOSING'
  | 'REVERSAL';

export type EntryStatus = 'DRAFT' | 'POSTED' | 'REVERSED';

export interface JournalLine {
  id: number;
  lineNumber: number;
  accountId: number;
  debit: string;
  credit: string;
  currency: string;
  description?: string;
}

export interface JournalEntry {
  id: number;
  entryNumber: string;
  entryDate: string; // YYYY-MM-DD
  periodId: number;
  entryType: EntryType;
  status: EntryStatus;
  description?: string;
  referenceType?: string;
  referenceId?: number;
  reversalOfId?: number;
  postedAt?: string;
  postedBy?: number;
  lines: JournalLine[];
}

export interface CreateJournalLineRequest {
  accountId: number;
  side: 'DEBIT' | 'CREDIT';
  amount: string; // parsed as BigDecimal on backend
  description?: string;
}

export interface CreateJournalEntryRequest {
  entryDate: string;
  periodId: number;
  entryType: EntryType;
  description?: string;
  referenceType?: string;
  referenceId?: number;
  idempotencyKey?: string;
  lines: CreateJournalLineRequest[];
}

export interface ReverseJournalEntryRequest {
  reversalDate?: string;
  reason?: string;
}
