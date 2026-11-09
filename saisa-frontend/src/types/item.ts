export interface Item {
  id: number;
  sku: string;
  name: string;
  description?: string | null;
  unitOfMeasure: string;
  hsnCode?: string | null;
  tracksInventory: boolean;
  salePrice?: number | null;
  purchasePrice?: number | null;
  reorderLevel?: number | null;
  active: boolean;
}

export interface CreateItemRequest {
  sku: string;
  name: string;
  description?: string;
  unitOfMeasure?: string;
  hsnCode?: string;
  tracksInventory?: boolean;
  salePrice?: number;
  purchasePrice?: number;
  reorderLevel?: number;
}
