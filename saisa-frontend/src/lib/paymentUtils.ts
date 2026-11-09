import type { PaymentMethod } from '../types/payment';

export const PAYMENT_METHODS: Array<{
  value: PaymentMethod;
  label: string;
  needsBank: boolean;
}> = [
  { value: 'CASH', label: 'Cash on Hand', needsBank: false },
  { value: 'BANK_TRANSFER', label: 'Bank Transfer / Wire', needsBank: true },
  { value: 'CHEQUE', label: 'Bank Cheque', needsBank: true },
  { value: 'UPI', label: 'Digital Wallet / Fonepay / UPI', needsBank: true },
  { value: 'NEFT', label: 'NEFT / IPS', needsBank: true },
  { value: 'RTGS', label: 'RTGS (Real Time Gross)', needsBank: true },
  { value: 'IMPS', label: 'ConnectIPS / IMPS', needsBank: true },
  { value: 'CARD', label: 'Debit / Credit Card', needsBank: true },
];

export function methodNeedsBank(method: PaymentMethod): boolean {
  return PAYMENT_METHODS.find((m) => m.value === method)?.needsBank ?? false;
}

export function generatePaymentNumber(mode: 'receipt' | 'payment'): string {
  const prefix = mode === 'receipt' ? 'RCPT' : 'PAY';
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const random = Math.floor(1000 + Math.random() * 9000);
  return `${prefix}-${year}${month}-${random}`;
}

