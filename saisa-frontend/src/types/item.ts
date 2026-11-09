export interface Item {
  id: number;
  sku: string;
  name: string;
  description?: string | null;
  unitOfMeasure: string;
  hsnCode?: string | null;
  tracksInventory: boolean;
  salePrice?: number | string | null;
  purchasePrice?: number | string | null;
  reorderLevel?: number | string | null;
  active: boolean;
}

export interface CreateItemRequest {
  sku: string;
  name: string;
  description?: string;
  unitOfMeasure?: string;
  hsnCode?: string;
  tracksInventory?: boolean;
  salePrice?: number | string;
  purchasePrice?: number | string;
  reorderLevel?: number | string;
}

export interface UpdateItemRequest {
  name?: string;
  description?: string;
  unitOfMeasure?: string;
  hsnCode?: string;
  salePrice?: number | string;
  purchasePrice?: number | string;
  reorderLevel?: number | string;
  active?: boolean;
}
