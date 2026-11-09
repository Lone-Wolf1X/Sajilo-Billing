export type DebitNoteStatus = 'DRAFT' | 'POSTED' | 'CANCELLED';

export interface DebitNoteLine {
  id?: number;
  lineNumber?: number;
  itemId: number | null;
  description: string | null;
  quantity: string;
  unitPrice: string;
  taxRate: string;
  lineSubtotal: string;
  lineTax: string;
  lineTotal: string;
}

export interface DebitNote {
  id: number;
  debitNoteNumber: string;
  debitNoteDate: string;
  vendorId: number;
  originalInvoiceId: number | null;
  reason: string | null;
  status: DebitNoteStatus;
  subtotal: string;
  taxAmount: string;
  totalAmount: string;
  currency: string;
  journalEntryId: number | null;
  postedAt?: string | null;
  postedBy?: number | null;
  lines: DebitNoteLine[];
}

export interface CreateDebitNoteLineRequest {
  itemId?: number | null;
  description?: string;
  quantity: string;
  unitPrice: string;
  taxRate: string;
}

export interface CreateDebitNoteRequest {
  debitNoteNumber: string;
  debitNoteDate: string;
  vendorId: number;
  originalInvoiceId?: number;
  reason?: string;
  idempotencyKey?: string;
  lines: CreateDebitNoteLineRequest[];
}

export interface DebitNoteListParams {
  from?: string;
  to?: string;
  vendorId?: number;
  status?: DebitNoteStatus;
  limit?: number;
}

