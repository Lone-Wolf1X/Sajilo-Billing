import type { AgingRow, AgingReport } from '../types/aging';

export interface CustomerAgingGroup {
  partyId: number;
  partyCode: string;
  partyName: string;
  invoices: AgingRow[];
  bucketCurrent: number;
  bucket1To30: number;
  bucket31To60: number;
  bucket61To90: number;
  bucket90Plus: number;
  total: number;
}

/**
 * Group per-invoice aging rows into party-level groups with bucket sums.
 * Rows are sorted by party name; invoices within are sorted by invoice date.
 */
export function groupAgingByParty(report: AgingReport): CustomerAgingGroup[] {
  const map = new Map<number | string, CustomerAgingGroup>();

  for (const row of report.rows) {
    const rawKey = row.partyId ?? (row as any).customerId ?? (row as any).vendorId ?? row.partyName;
    const key = rawKey;

    let group = map.get(key);
    if (!group) {
      group = {
        partyId: typeof rawKey === 'number' ? rawKey : 0,
        partyCode: row.partyCode ?? (row as any).customerCode ?? (row as any).vendorCode ?? '',
        partyName: row.partyName ?? (row as any).customerName ?? (row as any).vendorName ?? 'Unknown Party',
        invoices: [],
        bucketCurrent: 0,
        bucket1To30: 0,
        bucket31To60: 0,
        bucket61To90: 0,
        bucket90Plus: 0,
        total: 0,
      };
      map.set(key, group);
    }

    group.invoices.push(row);
    const amt =
      typeof row.outstanding === 'number'
        ? row.outstanding
        : parseFloat(String(row.outstanding)) || 0;
    group.total += amt;

    const b = (row.bucket || '').toUpperCase();
    if (b === 'CURRENT') {
      group.bucketCurrent += amt;
    } else if (b === '1-30' || b === '1_30' || b === '0-30') {
      group.bucket1To30 += amt;
    } else if (b === '31-60' || b === '31_60') {
      group.bucket31To60 += amt;
    } else if (b === '61-90' || b === '61_90') {
      group.bucket61To90 += amt;
    } else if (b === '90+' || b === '90PLUS' || b === 'OVER90') {
      group.bucket90Plus += amt;
    } else {
      // Default fallback based on daysOverdue
      if (row.daysOverdue <= 0) group.bucketCurrent += amt;
      else if (row.daysOverdue <= 30) group.bucket1To30 += amt;
      else if (row.daysOverdue <= 60) group.bucket31To60 += amt;
      else if (row.daysOverdue <= 90) group.bucket61To90 += amt;
      else group.bucket90Plus += amt;
    }
  }

  const result = Array.from(map.values());
  result.sort((a, b) => a.partyName.localeCompare(b.partyName));
  for (const g of result) {
    g.invoices.sort((a, b) => (a.invoiceDate || '').localeCompare(b.invoiceDate || ''));
  }
  return result;
}

export function exportAgingCSV(
  groups: CustomerAgingGroup[],
  mode: 'AR' | 'AP',
  asOf: string
) {
  const partyLabel = mode === 'AR' ? 'Customer' : 'Vendor';
  const headers = [partyLabel, 'Current', '1-30 Days', '31-60 Days', '61-90 Days', '90+ Days', 'Total Outstanding'];

  const fmt = (n: number) => n.toFixed(2);
  const lines: string[] = [];
  lines.push(`# Sajilo Billing - Accounts ${mode === 'AR' ? 'Receivable' : 'Payable'} Aging Matrix`);
  lines.push(`# As of Date: ${asOf}`);
  lines.push('');
  lines.push(headers.join(','));

  let tCur = 0,
    t1 = 0,
    t31 = 0,
    t61 = 0,
    t90 = 0,
    tTotal = 0;

  for (const g of groups) {
    lines.push(
      [
        `"${g.partyName.replace(/"/g, '""')}"`,
        fmt(g.bucketCurrent),
        fmt(g.bucket1To30),
        fmt(g.bucket31To60),
        fmt(g.bucket61To90),
        fmt(g.bucket90Plus),
        fmt(g.total),
      ].join(',')
    );
    tCur += g.bucketCurrent;
    t1 += g.bucket1To30;
    t31 += g.bucket31To60;
    t61 += g.bucket61To90;
    t90 += g.bucket90Plus;
    tTotal += g.total;
  }

  lines.push('');
  lines.push(
    [
      '"GRAND TOTAL"',
      fmt(tCur),
      fmt(t1),
      fmt(t31),
      fmt(t61),
      fmt(t90),
      fmt(tTotal),
    ].join(',')
  );

  const blob = new Blob([lines.join('\n')], { type: 'text/csv;charset=utf-8' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `${mode.toLowerCase()}-aging-${asOf}.csv`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

export function fmtAgingAmount(n: number | string | null | undefined): string {
  const v = typeof n === 'string' ? parseFloat(n) : n ?? 0;
  if (!v || isNaN(v) || Math.abs(v) < 0.005) return '—';
  return v.toLocaleString('en-IN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
}

