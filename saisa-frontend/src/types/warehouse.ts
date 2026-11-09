export interface Warehouse {
  id: number;
  code: string;
  name: string;
  address?: string | null;
  defaultWarehouse: boolean;
  active: boolean;
}

export interface CreateWarehouseRequest {
  code: string;
  name: string;
  address?: string;
  isDefault?: boolean;
}
