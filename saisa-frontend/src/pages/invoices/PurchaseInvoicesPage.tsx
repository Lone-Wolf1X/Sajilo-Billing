import React, { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Filter, RefreshCw, ShoppingCart, AlertCircle, CheckCircle2 } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Skeleton } from '../../components/ui/skeleton';
import { InvoiceStatusBadge, PaymentStatusBadge } from '../../components/invoices/InvoiceStatusBadge';
import { usePurchaseInvoices } from '../../hooks/usePurchaseInvoices';
import { useVendors } from '../../hooks/useVendors';
import { formatMoney, getPaymentStatus } from '../../lib/invoiceUtils';

export const PurchaseInvoicesPage: React.FC = () => {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedVendorId, setSelectedVendorId] = useState<string>('ALL');
  const [selectedStatus, setSelectedStatus] = useState<string>('ALL');
  const [fromDate, setFromDate] = useState<string>('');
  const [toDate, setToDate] = useState<string>('');

  const { vendors = [] } = useVendors();

  const { invoices = [], isLoading, refetch } = usePurchaseInvoices({
    from: fromDate || undefined,
    to: toDate || undefined,
    vendorId: selectedVendorId !== 'ALL' ? Number(selectedVendorId) : undefined,
    status: selectedStatus !== 'ALL' ? selectedStatus : undefined,
  });

  const vendorMap = useMemo(() => {
    const map = new Map<number, (typeof vendors)[0]>();
    for (const v of vendors) {
      map.set(v.id, v);
    }
    return map;
  }, [vendors]);

  // Client-side search by bill number, vendor bill # or vendor name
  const filteredInvoices = useMemo(() => {
    if (!searchQuery.trim()) return invoices;
    const q = searchQuery.toLowerCase().trim();
    return invoices.filter((inv) => {
      const invNum = inv.invoiceNumber.toLowerCase();
      const venInv = (inv.vendorInvoiceNo || '').toLowerCase();
      const vendor = vendorMap.get(inv.vendorId);
      const venName = vendor?.vendorName.toLowerCase() || '';
      return invNum.includes(q) || venInv.includes(q) || venName.includes(q);
    });
  }, [invoices, searchQuery, vendorMap]);

  // Metrics
  const metrics = useMemo(() => {
    let totalPurchased = 0;
    let totalPaid = 0;
    let totalPayable = 0;

    for (const inv of filteredInvoices) {
      totalPurchased += Number(inv.totalAmount) || 0;
      totalPaid += Number(inv.amountPaid) || 0;
      totalPayable += Number(inv.amountOutstanding) || 0;
    }

    return {
      count: filteredInvoices.length,
      totalPurchased,
      totalPaid,
      totalPayable,
    };
  }, [filteredInvoices]);

  return (
    <div className="space-y-5 max-w-7xl mx-auto pb-10">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-paper-border pb-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-xl font-serif font-bold text-brand-navy">
              Purchase Invoices & Bills
            </h1>
            <span className="key-tag text-[10px] bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border text-paper-muted">
              F9
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-0.5">
            Manage supplier purchases, accounts payable, and inventory receipt vouchers.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => refetch()}
            className="text-xs border-paper-border text-paper-muted hover:text-paper-text"
            title="Refresh Bills"
          >
            <RefreshCw className="h-3.5 w-3.5 mr-1" />
            Refresh
          </Button>

          <Button
            onClick={() => navigate('/purchase-invoices/new')}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4 shadow-sm flex items-center gap-1.5"
          >
            <Plus className="h-4 w-4" />
            <span>New Purchase Bill [F9]</span>
          </Button>
        </div>
      </div>

      {/* Metrics Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        {/* Count */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Bills Count</span>
            <ShoppingCart className="h-4 w-4 text-brand-navy" />
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-paper-text">
            {metrics.count}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Purchases recorded</div>
        </div>

        {/* Total Purchased */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Total Purchased</span>
            <span className="text-[10px] text-paper-muted">NPR</span>
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-brand-navy">
            {formatMoney(metrics.totalPurchased, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Gross procurement</div>
        </div>

        {/* Paid */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Vendor Payments</span>
            <CheckCircle2 className="h-4 w-4 text-[#2d6a4f]" />
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-[#2d6a4f]">
            {formatMoney(metrics.totalPaid, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Settled payables</div>
        </div>

        {/* Payables Due */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Accounts Payable</span>
            <AlertCircle className="h-4 w-4 text-[#7a2e2e]" />
          </div>
          <div
            className={`mt-1 font-mono text-xl font-bold ${
              metrics.totalPayable > 0 ? 'text-[#7a2e2e]' : 'text-paper-text'
            }`}
          >
            {formatMoney(metrics.totalPayable, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Owed to suppliers</div>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white border border-paper-border rounded-md p-3 shadow-subtle space-y-3">
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-5 gap-2.5">
          {/* Search */}
          <div className="relative md:col-span-2">
            <Search className="absolute left-2.5 top-2.5 h-3.5 w-3.5 text-paper-muted" />
            <Input
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search bill # or vendor..."
              className="text-xs h-9 pl-8 bg-paper-alt/50"
            />
          </div>

          {/* Vendor Filter */}
          <div>
            <select
              value={selectedVendorId}
              onChange={(e) => setSelectedVendorId(e.target.value)}
              className="w-full h-9 rounded-sm border border-paper-border bg-paper-alt/50 px-2.5 text-xs text-paper-text focus:outline-none focus:ring-1 focus:ring-brand-navy"
            >
              <option value="ALL">All Vendors</option>
              {vendors.map((v) => (
                <option key={v.id} value={v.id}>
                  {v.vendorName}
                </option>
              ))}
            </select>
          </div>

          {/* Status Filter */}
          <div>
            <select
              value={selectedStatus}
              onChange={(e) => setSelectedStatus(e.target.value)}
              className="w-full h-9 rounded-sm border border-paper-border bg-paper-alt/50 px-2.5 text-xs text-paper-text focus:outline-none focus:ring-1 focus:ring-brand-navy"
            >
              <option value="ALL">All Statuses</option>
              <option value="ISSUED">ISSUED</option>
              <option value="PAID">PAID</option>
              <option value="PARTIALLY_PAID">PARTIALLY PAID</option>
              <option value="DRAFT">DRAFT</option>
              <option value="CANCELLED">CANCELLED</option>
            </select>
          </div>

          {/* Clear Filters */}
          <div className="flex items-center gap-1.5">
            <Button
              variant="outline"
              size="sm"
              onClick={() => {
                setSearchQuery('');
                setSelectedVendorId('ALL');
                setSelectedStatus('ALL');
                setFromDate('');
                setToDate('');
              }}
              className="w-full text-xs h-9 border-paper-border text-paper-muted hover:text-paper-text"
            >
              <Filter className="h-3.5 w-3.5 mr-1" />
              Reset Filters
            </Button>
          </div>
        </div>

        {/* Date Filter Range */}
        <div className="flex flex-wrap items-center gap-3 pt-2 border-t border-paper-border/60 text-xs">
          <span className="text-paper-muted font-serif text-[11px] uppercase">
            Date Range:
          </span>
          <div className="flex items-center gap-1.5">
            <span className="text-paper-muted text-[11px]">From:</span>
            <Input
              type="date"
              value={fromDate}
              onChange={(e) => setFromDate(e.target.value)}
              className="text-xs h-7 w-32 bg-paper-alt/50 font-mono"
            />
          </div>
          <div className="flex items-center gap-1.5">
            <span className="text-paper-muted text-[11px]">To:</span>
            <Input
              type="date"
              value={toDate}
              onChange={(e) => setToDate(e.target.value)}
              className="text-xs h-7 w-32 bg-paper-alt/50 font-mono"
            />
          </div>
        </div>
      </div>

      {/* Bills Table */}
      {isLoading ? (
        <div className="bg-white border border-paper-border rounded-md p-4 space-y-3">
          <Skeleton className="h-8 w-full" />
          <Skeleton className="h-10 w-full" />
          <Skeleton className="h-10 w-full" />
        </div>
      ) : filteredInvoices.length === 0 ? (
        <div className="bg-white border border-paper-border rounded-md p-10 text-center space-y-3 shadow-subtle">
          <div className="mx-auto w-12 h-12 rounded-full bg-paper-alt flex items-center justify-center text-paper-muted border border-paper-border">
            📦
          </div>
          <h3 className="font-serif text-base font-bold text-brand-navy">
            No Purchase Bills Found
          </h3>
          <p className="text-xs text-paper-muted max-w-sm mx-auto">
            No supplier invoices match your current filter criteria.
          </p>
          <Button
            onClick={() => navigate('/purchase-invoices/new')}
            size="sm"
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif mt-2"
          >
            + Record New Purchase Bill [F9]
          </Button>
        </div>
      ) : (
        <div className="bg-white border border-paper-border rounded-md overflow-hidden shadow-subtle">
          <div className="overflow-x-auto">
            <table className="w-full text-xs border-collapse min-w-[850px]">
              <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
                <tr>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-32">
                    Bill #
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-24">
                    Date
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
                    Supplier / Vendor
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-32">
                    Supplier Ref #
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-24">
                    Due Date
                  </th>
                  <th className="px-2.5 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border w-24">
                    Status
                  </th>
                  <th className="px-2.5 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border w-24">
                    Payment
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-28">
                    Total (NPR)
                  </th>
                  <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right w-28">
                    Outstanding
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-paper-border">
                {filteredInvoices.map((inv) => {
                  const ven = vendorMap.get(inv.vendorId);
                  const pStatus = getPaymentStatus(inv);

                  return (
                    <tr
                      key={inv.id}
                      className="hover:bg-paper-warm/30 transition-colors"
                    >
                      <td className="px-3 py-2.5 font-mono font-bold text-brand-navy border-r border-paper-border">
                        {inv.invoiceNumber}
                      </td>

                      <td className="px-3 py-2.5 font-mono text-paper-muted border-r border-paper-border">
                        {inv.invoiceDate}
                      </td>

                      <td className="px-3 py-2.5 border-r border-paper-border">
                        <div className="font-medium text-paper-text">
                          {inv.vendorName || ven?.vendorName || `Vendor #${inv.vendorId}`}
                        </div>
                        {ven?.vendorCode && (
                          <span className="font-mono text-[10px] text-paper-muted">
                            {ven.vendorCode}
                          </span>
                        )}
                      </td>

                      <td className="px-3 py-2.5 font-mono text-paper-muted border-r border-paper-border">
                        {inv.vendorInvoiceNo || '—'}
                      </td>

                      <td className="px-3 py-2.5 font-mono text-paper-muted border-r border-paper-border">
                        {inv.dueDate || '—'}
                      </td>

                      <td className="px-2.5 py-2 text-center border-r border-paper-border">
                        <InvoiceStatusBadge status={inv.status} />
                      </td>

                      <td className="px-2.5 py-2 text-center border-r border-paper-border">
                        <PaymentStatusBadge status={pStatus} />
                      </td>

                      <td className="px-3 py-2.5 text-right font-mono font-medium text-paper-text border-r border-paper-border">
                        {formatMoney(inv.totalAmount, '')}
                      </td>

                      <td className="px-3 py-2.5 text-right font-mono font-bold">
                        <span
                          className={
                            Number(inv.amountOutstanding) > 0
                              ? 'text-[#7a2e2e]'
                              : 'text-paper-muted'
                          }
                        >
                          {formatMoney(inv.amountOutstanding, '')}
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          <div className="bg-paper-alt px-4 py-2 border-t border-paper-border flex items-center justify-between text-xs text-paper-muted">
            <span>Showing {filteredInvoices.length} bill(s)</span>
            <span className="font-serif italic text-[11px]">
              Purchases automatically track accounts payable and inventory valuation
            </span>
          </div>
        </div>
      )}
    </div>
  );
};
