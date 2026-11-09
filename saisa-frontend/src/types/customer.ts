export interface Customer {
  id: number;
  customerCode: string;
  customerName: string;
  gstin?: string | null;
  pan?: string | null;
  email?: string | null;
  phone?: string | null;
  billingAddress?: string | null;
  state?: string | null;
  active: boolean;
}

export interface CreateCustomerRequest {
  customerCode: string;
  customerName: string;
  gstin?: string;
  pan?: string;
  email?: string;
  phone?: string;
  billingAddress?: string;
  state?: string;
}

