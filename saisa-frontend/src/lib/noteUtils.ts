export function generateCreditNoteNumber(existing: string[]): string {
  const year = new Date().getFullYear();
  const prefix = `CN-${year}-`;
  const nums = existing
    .filter(n => n.startsWith(prefix))
    .map(n => parseInt(n.slice(prefix.length), 10))
    .filter(n => !isNaN(n));
  const next = nums.length > 0 ? Math.max(...nums) + 1 : 1;
  return `${prefix}${next.toString().padStart(4, '0')}`;
}

export function generateDebitNoteNumber(existing: string[]): string {
  const year = new Date().getFullYear();
  const prefix = `DN-${year}-`;
  const nums = existing
    .filter(n => n.startsWith(prefix))
    .map(n => parseInt(n.slice(prefix.length), 10))
    .filter(n => !isNaN(n));
  const next = nums.length > 0 ? Math.max(...nums) + 1 : 1;
  return `${prefix}${next.toString().padStart(4, '0')}`;
}

// Recompute line values from qty/price/taxRate
export function computeLineTotals(
  quantity: string,
  unitPrice: string,
  taxRate: string,
): { lineSubtotal: string; lineTax: string; lineTotal: string } {
  const q = parseFloat(quantity) || 0;
  const p = parseFloat(unitPrice) || 0;
  const r = parseFloat(taxRate) || 0;

  const subtotal = q * p;
  const tax = subtotal * r;
  const total = subtotal + tax;

  return {
    lineSubtotal: subtotal.toFixed(4),
    lineTax: tax.toFixed(4),
    lineTotal: total.toFixed(4),
  };
}

