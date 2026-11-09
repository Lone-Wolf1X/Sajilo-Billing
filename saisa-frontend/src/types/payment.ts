export type PartyType = 'CUSTOMER' | 'VENDOR';
export type PaymentMethod =
  | 'CASH'
  | 'BANK_TRANSFER'
  | 'CHEQUE'
  | 'UPI'
  | 'NEFT'
  | 'RTGS'
  | 'IMPS'
  | 'CARD';
export type PaymentStatus = 'DRAFT' | 'POSTED' | 'REVERSED';

export interface PaymentAllocation {
  invoiceType: 'SALES' | 'PURCHASE';
  invoiceId: number;
  amount: string | number;
}

export interface Payment {
  id: number;
  paymentNumber: string;
  paymentDate: string;
  amount: string | number;
  unallocatedAmount: string | number;
  currency: string;
  partyType: PartyType;
  partyId: number;
  partyName?: string;
  paymentMethod: PaymentMethod;
  bankAccountId: number | null;
  referenceNo: string | null;
  status: PaymentStatus;
  journalEntryId: number | null;
  allocations: PaymentAllocation[];
}

export interface CreatePaymentAllocationRequest {
  invoiceType: 'SALES' | 'PURCHASE';
  invoiceId: number;
  amount: string;
}

export interface CreatePaymentRequest {
  paymentNumber: string;
  paymentDate: string;
  amount: string;
  partyType: PartyType;
  partyId: number;
  paymentMethod: PaymentMethod;
  bankAccountId?: number;
  referenceNo?: string;
  notes?: string;
  idempotencyKey?: string;
  allocations?: CreatePaymentAllocationRequest[];
}

export interface PaymentListParams {
  from?: string;
  to?: string;
  partyType?: PartyType;
  partyId?: number;
  status?: PaymentStatus;
  limit?: number;
}
