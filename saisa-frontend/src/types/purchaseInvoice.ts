export interface PurchaseInvoiceLine {
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

export interface PurchaseInvoice {
  id: number;
  invoiceNumber: string;
  vendorInvoiceNo?: string | null;
  invoiceDate: string;
  dueDate?: string | null;
  vendorId: number;
  vendorName?: string;
  warehouseId?: number | null;
  status: string;
  subtotal: number | string;
  taxAmount: number | string;
  totalAmount: number | string;
  amountPaid: number | string;
  amountOutstanding: number | string;
  currency: string;
  journalEntryId?: number | null;
  lines: PurchaseInvoiceLine[];
}

export interface CreatePurchaseInvoiceLineRequest {
  itemId?: number;
  description?: string;
  quantity: string;
  unitPrice: string;
  taxRate: string;
}

export interface CreatePurchaseInvoiceRequest {
  invoiceNumber: string;
  vendorInvoiceNo?: string;
  invoiceDate: string;
  dueDate?: string;
  vendorId: number;
  warehouseId?: number;
  notes?: string;
  idempotencyKey?: string;
  lines: CreatePurchaseInvoiceLineRequest[];
}

export interface PurchaseInvoiceListParams {
  from?: string;
  to?: string;
  vendorId?: number;
  status?: string;
  limit?: number;
}

