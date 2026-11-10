import React from 'react';
import type { SalesInvoice, SalesInvoiceLine } from '../../types/salesInvoice';
import type { Customer } from '../../types/customer';
import type { Warehouse } from '../../types/warehouse';
import type { CompanyProfile } from '../../types/setup';
import { formatMoney, amountToWords } from '../../lib/invoiceUtils';

interface Props {
  invoice: SalesInvoice;
  customer?: Customer;
  warehouse?: Warehouse;
  profile?: CompanyProfile;
}

export const NepaliRedWhiteBill: React.FC<Props> = ({
  invoice,
  customer,
  profile,
}) => {
  // Normalize 9 PAN digits
  const rawPan = profile?.panVatNo || profile?.pan || '123456789';
  const panDigits = rawPan.replace(/\D/g, '').padEnd(9, ' ').slice(0, 9).split('');

  const custPanRaw = customer?.pan || customer?.gstin || '';
  const custPanDigits = custPanRaw ? custPanRaw.replace(/\D/g, '').padEnd(9, ' ').slice(0, 9).split('') : null;

  const words = amountToWords(invoice.totalAmount);

  return (
    <div className="bg-white border-2 border-red-600 rounded p-6 sm:p-8 max-w-2xl mx-auto shadow-sm text-red-800 font-serif">
      {/* Top Phone & Header */}
      <div className="border-b-2 border-red-600 pb-3 mb-4 text-center relative">
        <div className="text-right text-xs font-mono font-bold text-red-700">
          फोन नं.: {profile?.phone || profile?.authorizedPersonPhone || '०१-४XXXXXX'}
        </div>

        <h1 className="text-2xl sm:text-3xl font-extrabold text-red-800 tracking-wide mt-1">
          {profile?.companyNameNepali || profile?.companyName || 'सजिलो ट्रेडिङ एण्ड सप्लायर्स'}
        </h1>

        {profile?.companyNameNepali && profile?.companyName && (
          <p className="text-sm font-semibold text-red-700 tracking-wider uppercase">
            {profile.companyName}
          </p>
        )}

        <p className="text-xs font-medium text-red-700 mt-1">
          {profile?.toleStreet ? `${profile.toleStreet}, ` : ''}
          {profile?.district || 'काठमाडौँ'}, {profile?.province || 'नेपाल'}
        </p>

        {/* PAN Box Display */}
        <div className="flex items-center justify-center gap-2 mt-2.5">
          <span className="text-xs font-bold text-red-800 uppercase tracking-wider">
            स्थायी लेखा नं. (PAN No.):
          </span>
          <div className="inline-flex border-2 border-red-700 bg-red-50/70 shadow-2xs">
            {panDigits.map((digit: string, i: number) => (
              <span
                key={i}
                className="w-6 h-6 border-r border-red-600 last:border-r-0 flex items-center justify-center font-mono font-bold text-xs text-red-900"
              >
                {digit}
              </span>
            ))}
          </div>
        </div>

        <div className="mt-3">
          <span className="inline-block px-5 py-0.5 border border-red-600 bg-red-50 text-red-900 font-bold text-xs tracking-widest rounded-full uppercase">
            {invoice.taxAmount && Number(invoice.taxAmount) > 0 ? 'कर बीजक (TAX INVOICE)' : 'बिल / नगद रसिद (CASH MEMO)'}
          </span>
        </div>
      </div>

      {/* Bill Metadata Grid */}
      <div className="grid grid-cols-2 gap-4 text-xs mb-4 pb-3 border-b border-dashed border-red-400">
        <div className="space-y-1.5">
          <div className="flex items-baseline">
            <span className="font-bold text-red-800 whitespace-nowrap mr-2">श्री (M/s):</span>
            <span className="flex-1 border-b border-dotted border-red-400 font-semibold text-neutral-900 pl-1">
              {customer?.customerName || `Customer #${invoice.customerId}`}
            </span>
          </div>

          <div className="flex items-baseline">
            <span className="font-bold text-red-800 whitespace-nowrap mr-2">ठेगाना (Address):</span>
            <span className="flex-1 border-b border-dotted border-red-400 text-neutral-900 pl-1">
              {customer?.billingAddress || '—'}
            </span>
          </div>

          {custPanDigits && (
            <div className="flex items-center pt-1">
              <span className="font-bold text-red-800 whitespace-nowrap mr-2">ग्राहकको PAN:</span>
              <div className="inline-flex border border-red-600 bg-white">
                {custPanDigits.map((d: string, i: number) => (
                  <span
                    key={i}
                    className="w-5 h-5 border-r border-red-500 last:border-r-0 flex items-center justify-center font-mono font-bold text-[11px] text-neutral-900"
                  >
                    {d}
                  </span>
                ))}
              </div>
            </div>
          )}
        </div>

        <div className="space-y-1.5 text-right font-mono">
          <div className="flex justify-end items-baseline">
            <span className="font-bold font-serif text-red-800 mr-2">बिल नं. (Bill No):</span>
            <span className="font-bold text-red-900 text-sm font-mono">{invoice.invoiceNumber}</span>
          </div>

          <div className="flex justify-end items-baseline">
            <span className="font-serif text-red-800 mr-2">मिति (Date):</span>
            <span className="text-neutral-900">{invoice.invoiceDate}</span>
          </div>

          <div className="flex justify-end items-baseline">
            <span className="font-serif text-red-800 mr-2">भुक्तानी शर्त:</span>
            <span className="text-neutral-900 font-serif">{invoice.dueDate || 'नगद / चालु'}</span>
          </div>
        </div>
      </div>

      {/* Main Items Table */}
      <div className="border-2 border-red-600 mb-4 overflow-hidden">
        <table className="w-full text-xs border-collapse">
          <thead>
            <tr className="bg-red-50/80 border-b-2 border-red-600 text-red-900 font-bold">
              <th className="py-2 px-2 w-10 text-center border-r border-red-600">क्र.सं.</th>
              <th className="py-2 px-3 text-left border-r border-red-600">विवरण (Particulars)</th>
              <th className="py-2 px-2 w-16 text-center border-r border-red-600">परिमाण</th>
              <th className="py-2 px-3 w-24 text-right border-r border-red-600">दर (Rate)</th>
              <th className="py-2 px-3 w-28 text-right">जम्मा (Amount)</th>
            </tr>
          </thead>
          <tbody className="divide-y border-red-300">
            {invoice.lines.map((line: SalesInvoiceLine, idx: number) => {
              const lineTotal = Number(line.lineTotal) || (Number(line.quantity) * Number(line.unitPrice));
              return (
                <tr key={idx} className="text-neutral-900">
                  <td className="py-2 px-2 text-center font-mono text-red-700 border-r border-red-600">
                    {idx + 1}
                  </td>
                  <td className="py-2 px-3 border-r border-red-600 font-medium">
                    {line.description || 'General Goods'}
                  </td>
                  <td className="py-2 px-2 text-center font-mono border-r border-red-600">
                    {line.quantity}
                  </td>
                  <td className="py-2 px-3 text-right font-mono border-r border-red-600">
                    {formatMoney(line.unitPrice, '')}
                  </td>
                  <td className="py-2 px-3 text-right font-mono font-bold text-red-950">
                    {formatMoney(lineTotal, '')}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Totals & Words */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs pt-1 border-t border-red-300">
        <div className="space-y-2">
          <div className="border border-red-400 p-2.5 rounded bg-red-50/40">
            <span className="font-bold text-[11px] block text-red-800 mb-0.5">
              अक्षरेपी (In Words):
            </span>
            <p className="italic text-neutral-900 font-medium leading-relaxed">
              {words}
            </p>
          </div>
          <p className="text-[10px] text-neutral-500 italic">
            * भूलचुक लिनुदिनु। सामान फिर्ता लिइने छैन।
          </p>
        </div>

        <div className="space-y-1.5 font-mono text-xs">
          <div className="flex justify-between py-1 border-b border-red-200">
            <span className="font-serif text-red-800">कुल रकम (Subtotal):</span>
            <span className="font-semibold text-neutral-900">{formatMoney(invoice.subtotal)}</span>
          </div>

          {Number(invoice.taxAmount) > 0 && (
            <div className="flex justify-between py-1 border-b border-red-200">
              <span className="font-serif text-red-800">१३% भ्याट (VAT 13%):</span>
              <span className="font-semibold text-neutral-900">{formatMoney(invoice.taxAmount)}</span>
            </div>
          )}

          <div className="flex justify-between py-1.5 border-b-2 border-red-600 font-bold text-sm text-red-900">
            <span className="font-serif">खुद जम्मा (Grand Total):</span>
            <span>{formatMoney(invoice.totalAmount)}</span>
          </div>
        </div>
      </div>

      {/* Signature */}
      <div className="flex justify-between items-end pt-12 text-xs font-serif text-red-800">
        <div className="text-center">
          <div className="border-t border-dashed border-red-400 pt-1 px-4">
            ग्राहकको दस्तखत (Buyer)
          </div>
        </div>
        <div className="text-center">
          <div className="border-t border-dashed border-red-400 pt-1 px-6 font-bold">
            फाँटवाला / आधिकारिक दस्तखत
          </div>
        </div>
      </div>
    </div>
  );
};
