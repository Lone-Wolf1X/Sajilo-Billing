export interface Vendor {
  id: number;
  vendorCode: string;
  vendorName: string;
  gstin?: string | null;
  pan?: string | null;
  email?: string | null;
  phone?: string | null;
  billingAddress?: string | null;
  state?: string | null;
  active: boolean;
}

export interface CreateVendorRequest {
  vendorCode: string;
  vendorName: string;
  gstin?: string;
  pan?: string;
  email?: string;
  phone?: string;
  billingAddress?: string;
  state?: string;
}

