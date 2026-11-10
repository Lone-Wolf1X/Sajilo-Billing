export interface D01SalesEntry {
  id: number;
  dateAd: string;
  dateBs: string;
  invoiceNumber: string;
  customerName: string;
  customerPan: string;
  totalAmount: number;
  nonTaxableAmount: number;
  taxableAmount: number;
  vatAmount: number;
  exportAmount: number;
}

export interface D02PurchaseEntry {
  id: number;
  dateAd: string;
  dateBs: string;
  invoiceNumber: string;
  supplierName: string;
  supplierPan: string;
  totalAmount: number;
  nonTaxableAmount: number;
  taxableAmount: number;
  vatAmount: number;
  importAmount: number;
}

export interface IrdTaxSummary {
  totalSalesAmount: number;
  totalSalesTaxable: number;
  totalSalesNonTaxable: number;
  totalSalesVat: number;
  totalSalesExport: number;
  totalPurchaseAmount: number;
  totalPurchaseTaxable: number;
  totalPurchaseNonTaxable: number;
  totalPurchaseVat: number;
  totalPurchaseImport: number;
  netVatPayable: number;
  salesCount: number;
  purchaseCount: number;
}

