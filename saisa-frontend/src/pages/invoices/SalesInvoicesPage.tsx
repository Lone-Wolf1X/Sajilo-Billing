import React, { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Filter, RefreshCw, FileText, AlertCircle, CheckCircle2 } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { SalesInvoiceListTable } from '../../components/invoices/SalesInvoiceListTable';
import { useSalesInvoices } from '../../hooks/useSalesInvoices';
import { useCustomers } from '../../hooks/useCustomers';
import { formatMoney } from '../../lib/invoiceUtils';
import type { SalesInvoice } from '../../types/salesInvoice';

export const SalesInvoicesPage: React.FC = () => {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCustomerId, setSelectedCustomerId] = useState<string>('ALL');
  const [selectedStatus, setSelectedStatus] = useState<string>('ALL');
  const [fromDate, setFromDate] = useState<string>('');
  const [toDate, setToDate] = useState<string>('');

  const { customers = [] } = useCustomers();

  const { invoices = [], isLoading, refetch } = useSalesInvoices({
    from: fromDate || undefined,
    to: toDate || undefined,
    customerId: selectedCustomerId !== 'ALL' ? Number(selectedCustomerId) : undefined,
    status: selectedStatus !== 'ALL' ? selectedStatus : undefined,
  });

  // Client-side search by invoice number or customer name
  const filteredInvoices = useMemo(() => {
    if (!searchQuery.trim()) return invoices;
    const q = searchQuery.toLowerCase().trim();
    return invoices.filter((inv) => {
      const invNum = inv.invoiceNumber.toLowerCase();
      const customer = customers.find((c) => c.id === inv.customerId);
      const custName = customer?.customerName.toLowerCase() || '';
      return invNum.includes(q) || custName.includes(q);
    });
  }, [invoices, searchQuery, customers]);

  // Executive Metrics
  const metrics = useMemo(() => {
    let totalBilled = 0;
    let totalPaid = 0;
    let totalOutstanding = 0;

    for (const inv of filteredInvoices) {
      totalBilled += Number(inv.totalAmount) || 0;
      totalPaid += Number(inv.amountPaid) || 0;
      totalOutstanding += Number(inv.amountOutstanding) || 0;
    }

    return {
      count: filteredInvoices.length,
      totalBilled,
      totalPaid,
      totalOutstanding,
    };
  }, [filteredInvoices]);

  const handlePrint = (invoice: SalesInvoice) => {
    navigate(`/invoices/${invoice.id}?print=true`);
  };

  return (
    <div className="space-y-5 max-w-7xl mx-auto pb-10">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-paper-border pb-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-xl font-serif font-bold text-brand-navy">
              Sales Invoices & Billing
            </h1>
            <span className="key-tag text-[10px] bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border text-paper-muted">
              F8
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-0.5">
            Manage tax invoices, receivables tracking, and customer billing vouchers.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => refetch()}
            className="text-xs border-paper-border text-paper-muted hover:text-paper-text"
            title="Refresh Invoices"
          >
            <RefreshCw className="h-3.5 w-3.5 mr-1" />
            Refresh
          </Button>

          <Button
            onClick={() => navigate('/invoices/new')}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4 shadow-sm flex items-center gap-1.5"
          >
            <Plus className="h-4 w-4" />
            <span>New Invoice [F8]</span>
          </Button>
        </div>
      </div>

      {/* Financial Metrics Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        {/* Count */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Invoices Count</span>
            <FileText className="h-4 w-4 text-brand-navy" />
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-paper-text">
            {metrics.count}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Active vouchers</div>
        </div>

        {/* Total Billed */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Total Billed</span>
            <span className="text-[10px] text-paper-muted">NPR</span>
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-brand-navy">
            {formatMoney(metrics.totalBilled, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Gross sales booked</div>
        </div>

        {/* Total Collected */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Collected / Paid</span>
            <CheckCircle2 className="h-4 w-4 text-[#2d6a4f]" />
          </div>
          <div className="mt-1 font-mono text-xl font-bold text-[#2d6a4f]">
            {formatMoney(metrics.totalPaid, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Settled receivables</div>
        </div>

        {/* Outstanding */}
        <div className="bg-white border border-paper-border rounded-md p-3.5 shadow-subtle">
          <div className="flex items-center justify-between text-paper-muted text-[11px] font-serif uppercase">
            <span>Receivables Due</span>
            <AlertCircle className="h-4 w-4 text-[#7a2e2e]" />
          </div>
          <div
            className={`mt-1 font-mono text-xl font-bold ${
              metrics.totalOutstanding > 0 ? 'text-[#7a2e2e]' : 'text-paper-text'
            }`}
          >
            {formatMoney(metrics.totalOutstanding, '')}
          </div>
          <div className="text-[10px] text-paper-muted mt-0.5">Pending collection</div>
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
              placeholder="Search by invoice # or customer..."
              className="text-xs h-9 pl-8 bg-paper-alt/50"
            />
          </div>

          {/* Customer Filter */}
          <div>
            <select
              value={selectedCustomerId}
              onChange={(e) => setSelectedCustomerId(e.target.value)}
              className="w-full h-9 rounded-sm border border-paper-border bg-paper-alt/50 px-2.5 text-xs text-paper-text focus:outline-none focus:ring-1 focus:ring-brand-navy"
            >
              <option value="ALL">All Customers</option>
              {customers.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.customerName}
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
                setSelectedCustomerId('ALL');
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

      {/* Invoices List Table */}
      <SalesInvoiceListTable
        invoices={filteredInvoices}
        customers={customers}
        isLoading={isLoading}
        onView={(id) => navigate(`/invoices/${id}`)}
        onPrint={handlePrint}
        onCreateNew={() => navigate('/invoices/new')}
      />
    </div>
  );
};
