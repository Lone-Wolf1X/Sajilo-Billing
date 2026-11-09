export type InvoiceStatus = 'DRAFT' | 'ISSUED' | 'PAID' | 'PARTIALLY_PAID' | 'CANCELLED';
export type PaymentStatus = 'PAID' | 'PARTIALLY_PAID' | 'OVERDUE' | 'UNPAID';

export interface SalesInvoiceLine {
  lineNumber?: number;
  itemId?: number | null;
  description: string;
  quantity: number | string;
  unitPrice: number | string;
  taxRate: number | string;
  lineSubtotal?: number | string;
  lineTax?: number | string;
  lineTotal?: number | string;
}

export interface SalesInvoice {
  id: number;
  invoiceNumber: string;
  invoiceDate: string;
  dueDate?: string | null;
  customerId: number;
  customerName?: string;
  warehouseId?: number | null;
  status: InvoiceStatus;
  subtotal: number | string;
  taxAmount: number | string;
  totalAmount: number | string;
  amountPaid: number | string;
  amountOutstanding: number | string;
  currency: string;
  journalEntryId?: number | null;
  lines: SalesInvoiceLine[];
}

export interface CreateSalesInvoiceLineRequest {
  itemId?: number;
  description?: string;
  quantity: string;
  unitPrice: string;
  taxRate: string;
}

export interface CreateSalesInvoiceRequest {
  invoiceNumber: string;
  invoiceDate: string;
  dueDate?: string;
  customerId: number;
  warehouseId?: number;
  notes?: string;
  idempotencyKey?: string;
  lines: CreateSalesInvoiceLineRequest[];
}

export interface SalesInvoiceListParams {
  from?: string;
  to?: string;
  customerId?: number;
  status?: string;
  limit?: number;
}
