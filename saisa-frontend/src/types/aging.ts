export interface AgingRow {
  partyId: number;
  partyCode: string;
  partyName: string;
  invoiceId: number;
  invoiceNumber: string;
  invoiceDate: string;
  dueDate: string | null;
  totalAmount: number | string;
  amountPaid: number | string;
  outstanding: number | string;
  daysOverdue: number;
  bucket: string;
}

export interface AgingReport {
  asOfDate: string;
  partyType: 'CUSTOMER' | 'VENDOR';
  rows: AgingRow[];
  bucket0To30: number | string;
  bucket31To60: number | string;
  bucket61To90: number | string;
  bucket90Plus: number | string;
  totalOutstanding: number | string;
}

