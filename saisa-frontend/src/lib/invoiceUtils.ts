import type { PaymentStatus } from '../types/salesInvoice';

export function getPaymentStatus(invoice: {
  totalAmount: number | string;
  amountPaid?: number | string | null;
  dueDate?: string | null;
}): PaymentStatus {
  const total = Number(invoice.totalAmount) || 0;
  const paid = Number(invoice.amountPaid) || 0;

  if (total > 0 && paid >= total) {
    return 'PAID';
  }

  if (paid > 0 && paid < total) {
    return 'PARTIALLY_PAID';
  }

  if (invoice.dueDate) {
    const due = new Date(invoice.dueDate);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (due < today) {
      return 'OVERDUE';
    }
  }

  return 'UNPAID';
}

export function formatMoney(
  amount: number | string | null | undefined,
  currency = 'NPR'
): string {
  if (amount === null || amount === undefined || amount === '') return '—';
  const num = typeof amount === 'string' ? parseFloat(amount) : amount;
  if (isNaN(num)) return '—';

  const formatted = num.toLocaleString('en-IN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });

  return `${currency} ${formatted}`;
}

export function generateInvoiceNumber(prefix = 'INV'): string {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const random = Math.floor(1000 + Math.random() * 9000);
  return `${prefix}-${year}${month}-${random}`;
}

export function calculateLineValues(
  quantity: number | string,
  unitPrice: number | string,
  taxRatePercent: number | string
) {
  const qty = parseFloat(String(quantity)) || 0;
  const price = parseFloat(String(unitPrice)) || 0;
  const taxPct = parseFloat(String(taxRatePercent)) || 0;

  const subtotal = Math.round(qty * price * 100) / 100;
  const tax = Math.round(subtotal * (taxPct / 100) * 100) / 100;
  const total = Math.round((subtotal + tax) * 100) / 100;

  return {
    subtotal: subtotal.toFixed(2),
    tax: tax.toFixed(2),
    total: total.toFixed(2),
  };
}

const ONES = [
  '',
  'One',
  'Two',
  'Three',
  'Four',
  'Five',
  'Six',
  'Seven',
  'Eight',
  'Nine',
  'Ten',
  'Eleven',
  'Twelve',
  'Thirteen',
  'Fourteen',
  'Fifteen',
  'Sixteen',
  'Seventeen',
  'Eighteen',
  'Nineteen',
];

const TENS = [
  '',
  '',
  'Twenty',
  'Thirty',
  'Forty',
  'Fifty',
  'Sixty',
  'Seventy',
  'Eighty',
  'Ninety',
];

function convertBelowThousand(n: number): string {
  let str = '';
  if (n >= 100) {
    str += ONES[Math.floor(n / 100)] + ' Hundred ';
    n %= 100;
  }
  if (n >= 20) {
    str += TENS[Math.floor(n / 10)] + ' ';
    n %= 10;
  }
  if (n > 0) {
    str += ONES[n] + ' ';
  }
  return str.trim();
}

/**
 * Converts numbers into words following the South Asian numbering format (Crore, Lakh, Thousand, Hundred).
 */
export function amountToWords(amount: number | string, currencyName = 'Rupees'): string {
  const num = typeof amount === 'string' ? parseFloat(amount) : amount;
  if (isNaN(num) || num === 0) return `Zero ${currencyName} Only`;

  const absNum = Math.abs(num);
  const wholePart = Math.floor(absNum);
  const decimalPart = Math.round((absNum - wholePart) * 100);

  let n = wholePart;
  const crore = Math.floor(n / 10000000);
  n %= 10000000;
  const lakh = Math.floor(n / 100000);
  n %= 100000;
  const thousand = Math.floor(n / 1000);
  n %= 1000;
  const remainder = n;

  let words = '';
  if (crore > 0) {
    words += convertBelowThousand(crore) + ' Crore ';
  }
  if (lakh > 0) {
    words += convertBelowThousand(lakh) + ' Lakh ';
  }
  if (thousand > 0) {
    words += convertBelowThousand(thousand) + ' Thousand ';
  }
  if (remainder > 0) {
    words += convertBelowThousand(remainder) + ' ';
  }

  words = words.trim();
  let result = words ? `${words} ${currencyName}` : '';

  if (decimalPart > 0) {
    const paiseWords = convertBelowThousand(decimalPart);
    result += (result ? ' and ' : '') + `${paiseWords} Paise`;
  }

  return (result + ' Only').trim();
}

