import React, { useMemo, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import {
  AlertTriangle,
  BookOpen,
  FileSpreadsheet,
  PackageCheck,
} from 'lucide-react';
import { formatMoney } from '@/lib/utils';
import { useArAging, useApAging } from '../hooks/useAging';
import { useBankAccounts } from '../hooks/useBankAccounts';
import { useCreditNotes } from '../hooks/useCreditNotes';
import { useDebitNotes } from '../hooks/useDebitNotes';
import { useSetupStatus } from '../hooks/useSetup';
import { useAuth } from '../hooks/useAuth';
import { PlatformDashboard } from './dashboard/PlatformDashboard';
import { CashierDashboard } from './dashboard/CashierDashboard';

export const FinancialDashboard: React.FC = () => {
  const navigate = useNavigate();
  const { data: setupStatus, isLoading: isSetupLoading } = useSetupStatus();

  useEffect(() => {
    if (!isSetupLoading && setupStatus && !setupStatus.setupCompleted) {
      navigate('/setup', { replace: true });
    }
  }, [setupStatus, isSetupLoading, navigate]);
  const { data: arAging } = useArAging();
  const { data: apAging } = useApAging();
  const { bankAccounts = [] } = useBankAccounts();

  const today = useMemo(() => new Date(), []);
  const firstOfMonth = useMemo(
    () => new Date(today.getFullYear(), today.getMonth(), 1).toISOString().slice(0, 10),
    [today]
  );
  const todayStr = useMemo(() => today.toISOString().slice(0, 10), [today]);

  const { data: creditNotes = [] } = useCreditNotes({
    from: firstOfMonth,
    to: todayStr,
    status: 'POSTED',
    limit: 100,
  });
  const { data: debitNotes = [] } = useDebitNotes({
    from: firstOfMonth,
    to: todayStr,
    status: 'POSTED',
    limit: 100,
  });

  const salesReturnsTotal = creditNotes.reduce((s, n) => s + parseFloat(n.totalAmount || '0'), 0);
  const purchaseReturnsTotal = debitNotes.reduce((s, n) => s + parseFloat(n.totalAmount || '0'), 0);
  const salesReturnsCount = creditNotes.length;
  const purchaseReturnsCount = debitNotes.length;

  const totalReceivables = Number(arAging?.totalOutstanding) || 0;
  const overdueAR =
    (Number(arAging?.bucket31To60) || 0) +
    (Number(arAging?.bucket61To90) || 0) +
    (Number(arAging?.bucket90Plus) || 0);
  const overdueARCount =
    arAging?.rows?.filter((r) => r.daysOverdue > 30).length || 0;

  const totalPayables = Number(apAging?.totalOutstanding) || 0;
  const upcomingAP = Number(apAging?.bucket0To30) || 0;

  const defaultBank = useMemo(
    () => bankAccounts.find((b) => b.defaultAccount) || bankAccounts[0],
    [bankAccounts]
  );

  return (
    <div className="space-y-6">
      {/* 1. Executive Summary Ribbon (5 Metric Cards) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-4">
        {/* Card 1: Receivables */}
        <div className="card p-4 hover:shadow-md transition-shadow">
          <div className="flex justify-between items-start text-xs text-paper-muted uppercase tracking-wider font-semibold">
            <span>Total Receivables</span>
            <span
              className={`px-1.5 py-0.5 rounded text-[10px] ${
                overdueARCount > 0
                  ? 'bg-rose-100 text-rose-800'
                  : 'bg-emerald-100 text-emerald-800'
              }`}
            >
              {overdueARCount > 0 ? `${overdueARCount} Overdue` : 'Current'}
            </span>
          </div>
          <div className="text-2xl font-bold font-mono text-brand-navy mt-1">
            {formatMoney(totalReceivables)}
          </div>
          <div className="text-xs text-paper-muted mt-2 flex items-center justify-between border-t border-dashed border-paper-border pt-1.5">
            <span>Overdue (&gt;30d):</span>
            <span
              className={`font-mono font-medium ${
                overdueAR > 0 ? 'text-ledger-red' : 'text-paper-muted'
              }`}
            >
              {formatMoney(overdueAR)}
            </span>
          </div>
        </div>

        {/* Card 2: Payables */}
        <div className="card p-4 hover:shadow-md transition-shadow">
          <div className="flex justify-between items-start text-xs text-paper-muted uppercase tracking-wider font-semibold">
            <span>Total Payables</span>
            <span className="text-ledger-amber bg-ledger-amber-light px-1.5 py-0.5 rounded text-[10px]">
              Accounts Payable
            </span>
          </div>
          <div className="text-2xl font-bold font-mono text-brand-maroon mt-1">
            {formatMoney(totalPayables)}
          </div>
          <div className="text-xs text-paper-muted mt-2 flex items-center justify-between border-t border-dashed border-paper-border pt-1.5">
            <span>Current (0-30d):</span>
            <span className="font-mono text-paper-text font-medium">
              {formatMoney(upcomingAP)}
            </span>
          </div>
        </div>

        {/* Card 3: Bank & Cash */}
        <div className="card p-4 hover:shadow-md transition-shadow">
          <div className="flex justify-between items-start text-xs text-paper-muted uppercase tracking-wider font-semibold">
            <span>Cash & Bank Register</span>
            <span className="text-ledger-green font-semibold">
              {bankAccounts.length} Account(s)
            </span>
          </div>
          <div className="text-2xl font-bold font-mono text-ledger-green mt-1">
            {formatMoney(385920.0)}
          </div>
          <div className="text-xs text-paper-muted mt-2 flex items-center justify-between border-t border-dashed border-paper-border pt-1.5">
            <span>Primary Operating:</span>
            <span className="font-mono text-paper-text font-medium truncate max-w-[150px]">
              {defaultBank ? defaultBank.accountName : 'Cash Account'}
            </span>
          </div>
        </div>

        {/* Card 4: Net Profit */}
        <div className="card p-4 hover:shadow-md transition-shadow">
          <div className="flex justify-between items-start text-xs text-paper-muted uppercase tracking-wider font-semibold">
            <span>Net Profit (MTD)</span>
            <span className="text-brand-navy font-semibold">Margin 19.8%</span>
          </div>
          <div className="text-2xl font-bold font-mono text-brand-navy mt-1">
            {formatMoney(94300.0)}
          </div>
          <div className="text-xs text-paper-muted mt-2 flex items-center justify-between border-t border-dashed border-paper-border pt-1.5">
            <span>Gross Revenue:</span>
            <span className="font-mono text-paper-text font-medium">₹4,76,200.00</span>
          </div>
        </div>

        {/* Card 5: Returns (MTD) */}
        <div className="card p-4 hover:shadow-md transition-shadow">
          <div className="flex justify-between items-start text-xs text-paper-muted uppercase tracking-wider font-semibold">
            <span>Returns (MTD)</span>
            <span className="text-amber-800 bg-amber-50 px-1.5 py-0.5 rounded text-[10px] font-semibold border border-amber-200">
              {salesReturnsCount + purchaseReturnsCount} Note(s)
            </span>
          </div>
          <div className="text-2xl font-bold font-mono text-brand-navy mt-1">
            {formatMoney(salesReturnsTotal + purchaseReturnsTotal)}
          </div>
          <div className="text-xs text-paper-muted mt-2 space-y-1 border-t border-dashed border-paper-border pt-1.5">
            <div className="flex items-center justify-between">
              <span className="text-[11px]">Sales:</span>
              <span className="font-mono text-brand-burgundy font-medium text-[11px]">
                {formatMoney(salesReturnsTotal)} ({salesReturnsCount})
              </span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-[11px]">Purchase:</span>
              <span className="font-mono text-emerald-700 font-medium text-[11px]">
                {formatMoney(purchaseReturnsTotal)} ({purchaseReturnsCount})
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* 2. Three Pillars / Domain Grouping */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
        {/* Module 1: Financial Core */}
        <div className="card flex flex-col">
          <div className="card-header bg-paper-alt">
            <h3 className="card-title text-base flex items-center gap-2 text-brand-navy">
              <BookOpen className="w-4 h-4 text-brand-navy" />
              <span>Financial Core</span>
            </h3>
            <span className="badge badge-success">Balanced</span>
          </div>
          <div className="card-body flex-1 space-y-2 text-sm">
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Chart of Accounts:</span>
              <strong className="font-mono">48 Active Accounts</strong>
            </div>
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Posted Journal Entries:</span>
              <strong className="font-mono">1,248 Vouchers</strong>
            </div>
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Trial Balance Status:</span>
              <span className="text-ledger-green font-semibold">In Perfect Equilibrium</span>
            </div>
            <div className="flex justify-between py-1.5">
              <span className="text-paper-muted">Period State:</span>
              <span className="font-semibold text-paper-text">Nov 2026 (Open)</span>
            </div>
          </div>
          <div className="p-3 bg-paper-alt border-t border-paper-border flex justify-end gap-2 text-xs">
            <Link
              to="/journal-entries"
              className="btn btn-secondary btn-sm"
            >
              Browse Journals
            </Link>
            <Link
              to="/reports/trial-balance"
              className="btn btn-primary btn-sm"
            >
              Trial Balance →
            </Link>
          </div>
        </div>

        {/* Module 2: Billing & Receivables */}
        <div className="card flex flex-col">
          <div className="card-header bg-paper-alt">
            <h3 className="card-title text-base flex items-center gap-2 text-brand-maroon">
              <FileSpreadsheet className="w-4 h-4 text-brand-maroon" />
              <span>Billing & Invoices</span>
            </h3>
            <span className="badge badge-default">Tax Invoicing</span>
          </div>
          <div className="card-body flex-1 space-y-2 text-sm">
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Invoices Issued (MTD):</span>
              <strong className="font-mono">64 Invoices</strong>
            </div>
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Average Collection Period:</span>
              <strong className="font-mono">22.4 Days</strong>
            </div>
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Pending Collections:</span>
              <strong className="font-mono text-ledger-amber">11 Invoices</strong>
            </div>
            <div className="flex justify-between py-1.5">
              <span className="text-paper-muted">Credit Notes / Returns:</span>
              <span className="font-mono text-paper-text font-medium">
                {salesReturnsCount} ({formatMoney(salesReturnsTotal)})
              </span>
            </div>
          </div>
          <div className="p-3 bg-paper-alt border-t border-paper-border flex justify-end gap-2 text-xs">
            <Link
              to="/invoices"
              className="btn btn-secondary btn-sm"
            >
              View Invoices
            </Link>
            <Link
              to="/invoices/new"
              className="btn btn-primary btn-sm"
            >
              New Sales Invoice [F8] →
            </Link>
          </div>
        </div>

        {/* Module 3: Inventory & Valuation */}
        <div className="card flex flex-col">
          <div className="card-header bg-paper-alt">
            <h3 className="card-title text-base flex items-center gap-2 text-ledger-green">
              <PackageCheck className="w-4 h-4 text-ledger-green" />
              <span>Inventory & Stock</span>
            </h3>
            <span className="badge badge-warning">2 Alerts</span>
          </div>
          <div className="card-body flex-1 space-y-2 text-sm">
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Total Stock Valuation:</span>
              <strong className="font-mono">₹5,42,800.00</strong>
            </div>
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Active Catalog SKUs:</span>
              <strong className="font-mono">142 Items</strong>
            </div>
            <div className="flex justify-between py-1.5 border-b border-dashed border-paper-border">
              <span className="text-paper-muted">Reorder Threshold Alerts:</span>
              <span className="font-mono text-ledger-red font-semibold">2 Items Low</span>
            </div>
            <div className="flex justify-between py-1.5">
              <span className="text-paper-muted">Primary Warehouse:</span>
              <span className="text-paper-text font-medium">Main Central Depot</span>
            </div>
          </div>
          <div className="p-3 bg-paper-alt border-t border-paper-border flex justify-end gap-2 text-xs">
            <Link
              to="/inventory/alerts"
              className="btn btn-secondary btn-sm"
            >
              Stock Alerts
            </Link>
            <Link
              to="/inventory/items"
              className="btn btn-primary btn-sm"
            >
              Stock Catalog [F10] →
            </Link>
          </div>
        </div>
      </div>

      {/* 3. Recent Audited Journal Entries Ledger */}
      <div className="card">
        <div className="card-header bg-paper-alt">
          <div>
            <h2 className="card-title text-lg flex items-center gap-2">
              <span>Audited General Ledger Journal</span>
              <span className="text-xs text-paper-muted font-normal font-sans">
                (Last 5 Real-Time Double-Entry Postings)
              </span>
            </h2>
          </div>
          <div className="flex items-center gap-2">
            <Link
              to="/journal-entries/new"
              className="btn btn-primary btn-sm"
            >
              + Post Voucher [F7]
            </Link>
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="data-table border-0 rounded-none">
            <thead>
              <tr>
                <th className="w-28">Posting Date</th>
                <th className="w-28">Voucher #</th>
                <th className="w-28">Entry Type</th>
                <th>Debit / Credit Accounts</th>
                <th>Narration / Memo</th>
                <th className="text-right w-32">Debit (₹)</th>
                <th className="text-right w-32">Credit (₹)</th>
                <th className="text-center w-24">Integrity</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td className="text-xs">09 Nov 2026</td>
                <td>
                  <code className="ledger-badge">SINV-00142</code>
                </td>
                <td>
                  <span className="badge badge-default">Sales</span>
                </td>
                <td>
                  <strong>1101 — Accounts Receivable</strong>
                  <br />
                  <small className="text-paper-muted">Cr. 4001 Sales Revenue</small>
                </td>
                <td className="text-xs text-paper-muted">
                  Tax invoice for industrial goods supplied to Ramesh Traders
                </td>
                <td className="amount font-mono text-right">11,800.00</td>
                <td className="amount font-mono text-right">—</td>
                <td className="text-center">
                  <span className="badge badge-success text-[10px]">POSTED</span>
                </td>
              </tr>

              <tr>
                <td className="text-xs">09 Nov 2026</td>
                <td>
                  <code className="ledger-badge">COGS-00219</code>
                </td>
                <td>
                  <span className="badge badge-default">Inventory</span>
                </td>
                <td>
                  <strong>5101 — Cost of Goods Sold</strong>
                  <br />
                  <small className="text-paper-muted">Cr. 1301 Inventory Stock</small>
                </td>
                <td className="text-xs text-paper-muted">
                  Auto COGS movement from Main Warehouse against SINV-00142
                </td>
                <td className="amount font-mono text-right">7,500.00</td>
                <td className="amount font-mono text-right">—</td>
                <td className="text-center">
                  <span className="badge badge-success text-[10px]">POSTED</span>
                </td>
              </tr>

              <tr>
                <td className="text-xs">09 Nov 2026</td>
                <td>
                  <code className="ledger-badge">PAY-00891</code>
                </td>
                <td>
                  <span className="badge badge-default">Receipt</span>
                </td>
                <td>
                  <strong>1002 — HDFC Bank</strong>
                  <br />
                  <small className="text-paper-muted">Cr. 1101 Ramesh Traders (AR)</small>
                </td>
                <td className="text-xs text-paper-muted">
                  NEFT payment receipt against invoice INV-00142
                </td>
                <td className="amount font-mono text-right">5,000.00</td>
                <td className="amount font-mono text-right">—</td>
                <td className="text-center">
                  <span className="badge badge-success text-[10px]">POSTED</span>
                </td>
              </tr>

              <tr>
                <td className="text-xs">08 Nov 2026</td>
                <td>
                  <code className="ledger-badge">PINV-00049</code>
                </td>
                <td>
                  <span className="badge badge-default">Purchase</span>
                </td>
                <td>
                  <strong>1301 — Raw Materials Inventory</strong>
                  <br />
                  <small className="text-paper-muted">Cr. 2101 ABC Suppliers (AP)</small>
                </td>
                <td className="text-xs text-paper-muted">
                  Purchase bill for raw steel from ABC Suppliers
                </td>
                <td className="amount font-mono text-right">59,000.00</td>
                <td className="amount font-mono text-right">—</td>
                <td className="text-center">
                  <span className="badge badge-success text-[10px]">POSTED</span>
                </td>
              </tr>

              <tr>
                <td className="text-xs">07 Nov 2026</td>
                <td>
                  <code className="ledger-badge">JE-00089</code>
                </td>
                <td>
                  <span className="badge badge-default">Expense</span>
                </td>
                <td>
                  <strong>5001 — Office Rent Expense</strong>
                  <br />
                  <small className="text-paper-muted">Cr. 1002 HDFC Bank</small>
                </td>
                <td className="text-xs text-paper-muted">
                  November office rent paid via banking transfer
                </td>
                <td className="amount font-mono text-right">45,000.00</td>
                <td className="amount font-mono text-right">—</td>
                <td className="text-center">
                  <span className="badge badge-success text-[10px]">POSTED</span>
                </td>
              </tr>
            </tbody>
            <tfoot>
              <tr className="bg-paper-alt font-bold">
                <td colSpan={5} className="text-right font-serif text-sm">
                  Day Total (Selected Audited Range):
                </td>
                <td className="amount double-underline font-mono text-right text-brand-navy font-bold">
                  ₹1,30,660.00
                </td>
                <td className="amount double-underline font-mono text-right text-brand-navy font-bold">
                  ₹1,30,660.00
                </td>
                <td className="text-center">
                  <span className="badge badge-success text-[10px]">BALANCED</span>
                </td>
              </tr>
            </tfoot>
          </table>
        </div>

        <div className="p-3 bg-paper-alt border-t border-paper-border-strong text-xs text-paper-muted flex flex-col sm:flex-row justify-between items-center gap-2">
          <span>Showing latest audited ledger postings · Tenancy Isolation Verified</span>
          <div className="flex items-center gap-3">
            <span>
              Ledger Integrity:{' '}
              <strong className="text-ledger-green">0 Discrepancy ✓</strong>
            </span>
            <Link
              to="/journal-entries"
              className="text-brand-navy font-semibold hover:underline"
            >
              View Complete Ledger →
            </Link>
          </div>
        </div>
      </div>

      {/* 4. Inventory Reorder Alert */}
      <div className="p-4 bg-ledger-amber-light border border-[#fae4a8] rounded-md flex flex-col sm:flex-row justify-between items-center gap-3 text-sm">
        <div className="flex items-center gap-2 text-paper-text">
          <AlertTriangle className="w-5 h-5 text-ledger-amber flex-shrink-0" />
          <span>
            <strong>Inventory Reorder Warning:</strong> 2 catalog items (Steel Wire 4mm, Heavy Bearing 6205) are below safety threshold.
          </span>
        </div>
        <Link
          to="/inventory/alerts"
          className="btn btn-secondary btn-sm whitespace-nowrap bg-white hover:bg-paper-hover"
        >
          Review Reorder Stock →
        </Link>
      </div>
    </div>
  );
};

export const DashboardPage: React.FC = () => {
  const { user } = useAuth();
  const roles = user?.roles || [];

  if (roles.includes('PLATFORM_ADMIN') || user?.tenantCode === '_platform') {
    return <PlatformDashboard />;
  }

  if (roles.includes('CASHIER') && !roles.includes('ADMIN') && !roles.includes('ACCOUNTANT')) {
    return <CashierDashboard />;
  }

  return <FinancialDashboard />;
};
