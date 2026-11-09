export type CreditNoteStatus = 'DRAFT' | 'POSTED' | 'CANCELLED';

export interface CreditNoteLine {
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

export interface CreditNote {
  id: number;
  creditNoteNumber: string;
  creditNoteDate: string;
  customerId: number;
  originalInvoiceId: number | null;
  reason: string | null;
  status: CreditNoteStatus;
  subtotal: string;
  taxAmount: string;
  totalAmount: string;
  currency: string;
  journalEntryId: number | null;
  postedAt?: string | null;
  postedBy?: number | null;
  lines: CreditNoteLine[];
}

export interface CreateCreditNoteLineRequest {
  itemId?: number | null;
  description?: string;
  quantity: string;
  unitPrice: string;
  taxRate: string;
}

export interface CreateCreditNoteRequest {
  creditNoteNumber: string;
  creditNoteDate: string;
  customerId: number;
  originalInvoiceId?: number;
  reason?: string;
  idempotencyKey?: string;
  lines: CreateCreditNoteLineRequest[];
}

export interface CreditNoteListParams {
  from?: string;
  to?: string;
  customerId?: number;
  status?: CreditNoteStatus;
  limit?: number;
}

