import React from 'react';
import { formatMoney, amountToWords, calculateLineValues } from '../../lib/invoiceUtils';
import type { InvoiceLineForm } from './InvoiceLinesTable';

interface Props {
  lines: InvoiceLineForm[];
}

export const InvoiceTotalsCard: React.FC<Props> = ({ lines }) => {
  let totalSubtotal = 0;
  let totalTax = 0;
  let grandTotal = 0;

  for (const line of lines) {
    const { subtotal, tax, total } = calculateLineValues(
      line.quantity,
      line.unitPrice,
      line.taxRate
    );
    totalSubtotal += parseFloat(subtotal);
    totalTax += parseFloat(tax);
    grandTotal += parseFloat(total);
  }

  // Round to 2 decimals
  totalSubtotal = Math.round(totalSubtotal * 100) / 100;
  totalTax = Math.round(totalTax * 100) / 100;
  grandTotal = Math.round(grandTotal * 100) / 100;

  const words = amountToWords(grandTotal);

  return (
    <div className="bg-white border border-paper-border rounded-md p-4 shadow-subtle space-y-4">
      <div className="space-y-2 text-xs">
        {/* Subtotal */}
        <div className="flex justify-between items-center text-paper-muted pb-1 border-b border-paper-border/60">
          <span className="font-serif">Subtotal:</span>
          <span className="font-mono font-medium text-paper-text">
            {formatMoney(totalSubtotal)}
          </span>
        </div>

        {/* Tax Amount */}
        <div className="flex justify-between items-center text-paper-muted pb-1 border-b border-paper-border/60">
          <span className="font-serif">Applicable VAT / Tax:</span>
          <span className="font-mono font-medium text-paper-text">
            {formatMoney(totalTax)}
          </span>
        </div>

        {/* Grand Total */}
        <div className="flex justify-between items-center pt-2">
          <span className="font-serif text-sm font-bold text-brand-navy">
            Invoice Total:
          </span>
          <span className="font-mono text-base font-bold text-brand-navy underline decoration-double decoration-brand-navy underline-offset-4">
            {formatMoney(grandTotal)}
          </span>
        </div>
      </div>

      {/* Amount in words banner */}
      <div className="bg-paper-alt/80 border border-paper-border/80 rounded px-3 py-2 text-xs">
        <span className="font-serif font-bold text-paper-muted uppercase text-[10px] block">
          Amount In Words
        </span>
        <span className="font-serif italic text-paper-text text-[11px] leading-relaxed">
          {words}
        </span>
      </div>
    </div>
  );
};
