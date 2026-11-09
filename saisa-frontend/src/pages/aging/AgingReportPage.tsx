import React, { useMemo, useState } from 'react';
import { Printer, Download, CheckCircle2, RefreshCw } from 'lucide-react';
import { AgingSummaryCards } from '../../components/aging/AgingSummaryCards';
import { AgingMatrixTable } from '../../components/aging/AgingMatrixTable';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Label } from '../../components/ui/label';
import { Skeleton } from '../../components/ui/skeleton';
import { useArAging, useApAging } from '../../hooks/useAging';
import { groupAgingByParty, exportAgingCSV } from '../../lib/agingUtils';
import { useAuthStore } from '../../stores/authStore';

interface Props {
  mode: 'AR' | 'AP';
}

export const AgingReportPage: React.FC<Props> = ({ mode }) => {
  const isAR = mode === 'AR';
  const { user } = useAuthStore();

  const [asOf, setAsOf] = useState(() => new Date().toISOString().slice(0, 10));

  const arQuery = useArAging(isAR ? asOf : undefined, isAR);
  const apQuery = useApAging(!isAR ? asOf : undefined, !isAR);

  const { data: report, isLoading, error, refetch } = isAR ? arQuery : apQuery;

  const groups = useMemo(
    () => (report ? groupAgingByParty(report) : []),
    [report]
  );

  const handlePrint = () => window.print();
  const handleExport = () => report && exportAgingCSV(groups, mode, asOf);

  const reportTitle = isAR
    ? 'Accounts Receivable (AR) Aging Analysis'
    : 'Accounts Payable (AP) Aging Analysis';

  return (
    <div className="space-y-5 max-w-7xl mx-auto pb-12">
      {/* Screen Header Bar (Hidden on print) */}
      <div className="no-print flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-paper-border pb-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-xl font-serif font-bold text-brand-navy">
              {reportTitle}
            </h1>
            <span className="key-tag text-[10px] bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border text-paper-muted">
              {isAR ? 'DEBTORS' : 'CREDITORS'}
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-0.5">
            {isAR
              ? 'Multi-bucket aging analysis of overdue customer receivables with invoice level drill-down.'
              : 'Multi-bucket aging schedule of supplier payables and procurement liability obligations.'}
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => refetch()}
            className="text-xs border-paper-border text-paper-muted hover:text-paper-text"
            title="Refresh Report"
          >
            <RefreshCw className="h-3.5 w-3.5 mr-1" />
            Refresh
          </Button>

          <Button
            variant="outline"
            size="sm"
            onClick={handleExport}
            disabled={groups.length === 0}
            className="text-xs border-paper-border text-paper-text hover:bg-paper-alt"
          >
            <Download className="h-3.5 w-3.5 mr-1" />
            Export CSV
          </Button>

          <Button
            onClick={handlePrint}
            disabled={groups.length === 0}
            className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4 shadow-sm flex items-center gap-1.5"
          >
            <Printer className="h-4 w-4" />
            <span>Print Aging Matrix</span>
          </Button>
        </div>
      </div>

      {/* Filter / As-Of Date Bar (Hidden on print) */}
      <div className="no-print bg-white border border-paper-border rounded-md p-3.5 shadow-subtle flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <Label htmlFor="asOfDate" className="text-xs font-serif font-bold text-paper-text">
            Aging As Of Date:
          </Label>
          <Input
            id="asOfDate"
            type="date"
            value={asOf}
            onChange={(e) => setAsOf(e.target.value)}
            className="text-xs h-8 w-36 bg-paper-alt/50 font-mono"
          />
        </div>
        <span className="text-[11px] text-paper-muted italic hidden sm:inline">
          💡 Historical aging snapshots allow reviewing debt distribution on any past fiscal cutoff date.
        </span>
      </div>

      {/* Print Document Header (Visible only when printing) */}
      <div className="print-only text-center border-b-2 border-paper-border-strong pb-4 mb-4">
        <h2 className="font-serif text-xl font-bold uppercase text-brand-navy">
          {user?.tenantCode || 'SAJILO TRADING & ENTERPRISE'}
        </h2>
        <h3 className="font-serif text-base font-bold uppercase mt-1">
          {reportTitle}
        </h3>
        <p className="text-xs text-paper-muted mt-0.5 font-mono">
          As of Cutoff Date: {new Date(asOf).toLocaleDateString('en-IN', {
            day: '2-digit',
            month: 'long',
            year: 'numeric',
          })}
        </p>
      </div>

      {/* Main Content Area */}
      {isLoading ? (
        <div className="space-y-4">
          <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
            {[1, 2, 3, 4, 5].map((i) => (
              <Skeleton key={i} className="h-20 w-full" />
            ))}
          </div>
          <Skeleton className="h-64 w-full" />
        </div>
      ) : error ? (
        <div className="bg-[#fdf2f2] border border-[#7a2e2e] text-[#7a2e2e] text-xs p-4 rounded-md">
          Failed to compute aging report: {(error as Error).message}
        </div>
      ) : !report || groups.length === 0 ? (
        <div className="bg-white border border-paper-border rounded-md p-12 text-center shadow-subtle space-y-3">
          <CheckCircle2 className="h-10 w-10 text-[#2d6a4f] mx-auto" />
          <h3 className="font-serif text-base font-bold text-brand-navy">
            All Accounts Settled & Clear!
          </h3>
          <p className="text-xs text-paper-muted max-w-sm mx-auto">
            No outstanding {isAR ? 'receivables' : 'payables'} exist as of{' '}
            {new Date(asOf).toLocaleDateString('en-IN', {
              day: '2-digit',
              month: 'short',
              year: 'numeric',
            })}.
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {/* Top 5 Metric Cards */}
          <AgingSummaryCards report={report} mode={mode} />

          {/* Aging Matrix Table with Row Expand */}
          <div className="bg-white border border-paper-border rounded-md overflow-hidden shadow-subtle">
            <AgingMatrixTable groups={groups} mode={mode} />

            <div className="bg-paper-alt px-4 py-2 border-t border-paper-border flex items-center justify-between text-xs text-paper-muted">
              <span>
                Report includes {groups.length} {isAR ? 'customer' : 'supplier'} entity group(s)
              </span>
              <span className="font-serif italic text-[11px]">
                Click any customer row above to expand individual voucher drill-downs
              </span>
            </div>
          </div>
        </div>
      )}

      {/* Print Audit Footer */}
      <div className="print-only text-[10px] text-paper-muted pt-3 border-t border-paper-border flex justify-between">
        <span>System Generated Financial Report</span>
        <span>Printed on {new Date().toLocaleDateString('en-IN')}</span>
      </div>
    </div>
  );
};
