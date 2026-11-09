import React, { useState, useMemo } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { Plus, Receipt, RefreshCw, Filter, ArrowDownLeft, ArrowUpRight } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Skeleton } from '../../components/ui/skeleton';
import { PaymentListTable } from '../../components/payments/PaymentListTable';
import { usePayments } from '../../hooks/usePayments';
import { useCustomers } from '../../hooks/useCustomers';
import { useVendors } from '../../hooks/useVendors';
import { formatMoney } from '../../lib/invoiceUtils';
import type { PartyType } from '../../types/payment';

type TabType = 'ALL' | 'RECEIPT' | 'PAYMENT';

export const PaymentsPage: React.FC = () => {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const initialTab = (searchParams.get('type') as TabType) || 'ALL';

  const today = useMemo(() => new Date().toISOString().slice(0, 10), []);
  const firstOfMonth = useMemo(() => {
    const d = new Date();
    return new Date(d.getFullYear(), d.getMonth(), 1).toISOString().slice(0, 10);
  }, []);

  const [tab, setTab] = useState<TabType>(initialTab);
  const [fromDate, setFromDate] = useState<string>(firstOfMonth);
  const [toDate, setToDate] = useState<string>(today);

  const partyTypeParam: PartyType | undefined =
    tab === 'RECEIPT' ? 'CUSTOMER' : tab === 'PAYMENT' ? 'VENDOR' : undefined;

  const { payments = [], isLoading, refetch } = usePayments({
    from: fromDate || undefined,
    to: toDate || undefined,
    partyType: partyTypeParam,
    limit: 100,
  });

  const { customers = [] } = useCustomers();
  const { vendors = [] } = useVendors();

  const handleTabChange = (t: TabType) => {
    setTab(t);
    const next = new URLSearchParams(searchParams);
    if (t === 'ALL') next.delete('type');
    else next.set('type', t);
    setSearchParams(next);
  };

  // Metrics
  const metrics = useMemo(() => {
    let moneyIn = 0;
    let moneyOut = 0;

    for (const p of payments) {
      if (p.status === 'POSTED') {
        const amt = Number(p.amount) || 0;
        if (p.partyType === 'CUSTOMER') {
          moneyIn += amt;
        } else {
          moneyOut += amt;
        }
      }
    }

    return {
      count: payments.length,
      moneyIn,
      moneyOut,
      netCash: moneyIn - moneyOut,
    };
  }, [payments]);

  return (
    <div className="space-y-5 max-w-7xl mx-auto pb-10">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-paper-border pb-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-xl font-serif font-bold text-brand-navy">
              Payments & Receipts
            </h1>
            <span className="key-tag text-[10px] bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border text-paper-muted">
              CASH & BANK
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-0.5">
            Record customer collections, supplier disbursements, and general cash flow transactions.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => refetch()}
            className="text-xs border-paper-border text-paper-muted hover:text-paper-text"
            title="Refresh Payments"
          >
            <RefreshCw className="h-3.5 w-3.5 mr-1" />
            Refresh
          </Button>

          <Button
            onClick={() => navigate('/payments/receipt')}
            className="bg-[#2d6a4f] hover:bg-[#24543e] text-white text-xs font-serif px-3.5 shadow-sm flex items-center gap-1.5"
          >
            <Plus className="h-3.5 w-3.5" />
            <span>New Receipt [F6]</span>
          </Button>

          <Button
            onClick={() => navigate('/payments/vendor')}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-3.5 shadow-sm flex items-center gap-1.5"
          >
            <Plus className="h-3.5 w-3.5" />
            <span>New Payment [F5]</span>
          </Button>
        </div>
      </div>

      {/* Cash Flow Metrics Ribbon */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        {/* Total Vouchers */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="text-paper-muted text-[11px] font-serif uppercase">
            Total Vouchers
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-paper-text">
            {metrics.count}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">In selected period</div>
        </div>

        {/* Money In */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Money Received (In)</span>
            <ArrowDownLeft className="h-3.5 w-3.5 text-[#2d6a4f]" />
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-[#2d6a4f]">
            {formatMoney(metrics.moneyIn, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Customer receipts</div>
        </div>

        {/* Money Out */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Money Disbursed (Out)</span>
            <ArrowUpRight className="h-3.5 w-3.5 text-[#7a2e2e]" />
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-[#7a2e2e]">
            {formatMoney(metrics.moneyOut, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Supplier payouts</div>
        </div>

        {/* Net Flow */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="text-paper-muted text-[11px] font-serif uppercase">
            Net Cash Flow
          </div>
          <div
            className={`mt-1 font-mono text-xl font-bold ${
              metrics.netCash >= 0 ? 'text-[#2d6a4f]' : 'text-[#7a2e2e]'
            }`}
          >
            {formatMoney(metrics.netCash, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Receipts − Payments</div>
        </div>
      </div>

      {/* Filter and Tab Bar */}
      <div className="bg-white border border-paper-border rounded-md p-3 shadow-subtle space-y-3">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          {/* Tabs */}
          <div className="flex items-center gap-1 border-b sm:border-b-0 border-paper-border pb-1 sm:pb-0">
            {(['ALL', 'RECEIPT', 'PAYMENT'] as TabType[]).map((t) => (
              <button
                key={t}
                onClick={() => handleTabChange(t)}
                className={`px-3 py-1.5 text-xs font-serif rounded transition-colors cursor-pointer ${
                  tab === t
                    ? 'bg-brand-navy text-white font-bold'
                    : 'text-paper-muted hover:text-paper-text hover:bg-paper-alt'
                }`}
              >
                {t === 'ALL'
                  ? 'All Transactions'
                  : t === 'RECEIPT'
                  ? 'Customer Receipts (In)'
                  : 'Vendor Payments (Out)'}
              </button>
            ))}
          </div>

          {/* Date Filters */}
          <div className="flex flex-wrap items-center gap-2 text-xs">
            <span className="text-paper-muted font-serif text-[11px] uppercase">
              Date:
            </span>
            <Input
              type="date"
              value={fromDate}
              onChange={(e) => setFromDate(e.target.value)}
              className="text-xs h-8 w-32 bg-paper-alt/50 font-mono"
            />
            <span className="text-paper-muted text-xs">to</span>
            <Input
              type="date"
              value={toDate}
              onChange={(e) => setToDate(e.target.value)}
              className="text-xs h-8 w-32 bg-paper-alt/50 font-mono"
            />
            <Button
              variant="outline"
              size="sm"
              onClick={() => {
                setFromDate('');
                setToDate('');
              }}
              className="h-8 text-xs border-paper-border text-paper-muted hover:text-paper-text"
              title="Clear date filter"
            >
              <Filter className="h-3 w-3 mr-1" />
              Reset
            </Button>
          </div>
        </div>
      </div>

      {/* Content Table / Empty State */}
      <div className="bg-white border border-paper-border rounded-md overflow-hidden shadow-subtle">
        {isLoading ? (
          <div className="p-4 space-y-3">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
        ) : payments.length === 0 ? (
          <div className="p-12 text-center space-y-3">
            <div className="mx-auto w-12 h-12 rounded-full bg-paper-alt flex items-center justify-center text-paper-muted border border-paper-border">
              <Receipt className="h-6 w-6 text-brand-navy" />
            </div>
            <h3 className="font-serif text-base font-bold text-brand-navy">
              No Payment Transactions Found
            </h3>
            <p className="text-xs text-paper-muted max-w-sm mx-auto">
              No money receipts or vendor disbursement vouchers match the current filter range.
            </p>
            <div className="flex items-center justify-center gap-2 pt-1">
              <Button
                onClick={() => navigate('/payments/receipt')}
                size="sm"
                className="bg-[#2d6a4f] hover:bg-[#24543e] text-white text-xs font-serif"
              >
                + Record Customer Receipt [F6]
              </Button>
              <Button
                onClick={() => navigate('/payments/vendor')}
                size="sm"
                variant="outline"
                className="text-xs font-serif border-paper-border"
              >
                + Record Vendor Payment [F5]
              </Button>
            </div>
          </div>
        ) : (
          <PaymentListTable
            payments={payments}
            customers={customers}
            vendors={vendors}
          />
        )}

        <div className="bg-paper-alt px-4 py-2 border-t border-paper-border flex items-center justify-between text-xs text-paper-muted">
          <span>Showing {payments.length} voucher(s)</span>
          <span className="font-serif italic text-[11px]">
            Click any row to open the complete printable payment voucher
          </span>
        </div>
      </div>
    </div>
  );
};
