import React from 'react';
import { Link } from 'react-router-dom';
import {
  ShoppingCart,
  Receipt,
  Package,
  PlusCircle,
  Printer,
  ArrowRight,
  TrendingUp,
} from 'lucide-react';
import { useSalesInvoices } from '../../hooks/useSalesInvoices';
import { useAuth } from '../../hooks/useAuth';
import { formatMoney } from '../../lib/utils';

export const CashierDashboard: React.FC = () => {
  const { user } = useAuth();
  const { invoices = [], isLoading } = useSalesInvoices({ limit: 10 });

  // Calculate today's stats
  const todayStr = new Date().toISOString().slice(0, 10);
  const todayInvoices = invoices.filter(
    (inv) => inv.invoiceDate && inv.invoiceDate.slice(0, 10) === todayStr
  );
  const todayTotal = todayInvoices.reduce(
    (sum, inv) => sum + parseFloat(String(inv.totalAmount || '0')),
    0
  );

  return (
    <div className="space-y-6 max-w-7xl mx-auto p-4 md:p-6">
      {/* Welcome & Fast Terminal Action Hero */}
      <div className="bg-gradient-to-r from-emerald-800 via-emerald-700 to-teal-800 text-white rounded-xl p-6 md:p-8 shadow-md relative overflow-hidden">
        <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div className="space-y-2">
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/15 backdrop-blur-xs text-xs font-semibold text-emerald-100">
              <ShoppingCart className="w-3.5 h-3.5 text-amber-300" />
              <span>POS काउन्टर टर्मिनल (Billing Counter Station)</span>
            </div>
            <h1 className="text-2xl md:text-3xl font-serif font-bold text-white tracking-wide">
              नमस्ते, {user?.fullName || user?.username}
            </h1>
            <p className="text-sm text-emerald-100/90 max-w-xl">
              तपाईंको बिलिङ काउन्टर तयार छ। ग्राहकलाई तुरुन्त बिल जारी गर्न तलको <strong>[F8] नयाँ बिक्री बिल</strong> बटन थिच्नुहोस्।
            </p>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <Link
              to="/invoices/new"
              className="inline-flex items-center gap-2 px-5 py-3 bg-amber-400 hover:bg-amber-500 text-neutral-900 font-bold text-sm rounded-lg shadow-lg hover:shadow-xl transition-all transform hover:-translate-y-0.5"
            >
              <PlusCircle className="w-5 h-5 text-neutral-900" />
              <span>[F8] नयाँ बिक्री बिल बनाउनुहोस्</span>
            </Link>

            <Link
              to="/payments/receipt"
              className="inline-flex items-center gap-2 px-4 py-3 bg-white/15 hover:bg-white/25 text-white font-semibold text-sm rounded-lg border border-white/20 transition-colors"
            >
              <Receipt className="w-4 h-4" />
              <span>[F6] ग्राहक भुक्तानी रसिद</span>
            </Link>
          </div>
        </div>
      </div>

      {/* 3 Cashier Stat Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-white border border-neutral-300 rounded-lg p-5 shadow-xs">
          <div className="flex items-center justify-between text-neutral-500 mb-1">
            <span className="text-xs font-semibold uppercase tracking-wider">आजको कुल बिक्री (Today's Sales)</span>
            <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-700 flex items-center justify-center">
              <TrendingUp className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-bold font-serif text-neutral-900">
            {formatMoney(todayTotal)}
          </div>
          <div className="mt-2 text-xs text-neutral-500">
            आज जारी भएका कुल बिलहरू: <strong>{todayInvoices.length}</strong>
          </div>
        </div>

        <div className="bg-white border border-neutral-300 rounded-lg p-5 shadow-xs">
          <div className="flex items-center justify-between text-neutral-500 mb-1">
            <span className="text-xs font-semibold uppercase tracking-wider">काउन्टर रसिदहरू (Receipts)</span>
            <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-700 flex items-center justify-center">
              <Receipt className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-bold font-serif text-neutral-900">
            {invoices.length}
          </div>
          <div className="mt-2 text-xs text-neutral-500">
            पछिल्ला जारी भएका बिलहरूको सूची
          </div>
        </div>

        <div className="bg-white border border-neutral-300 rounded-lg p-5 shadow-xs">
          <div className="flex items-center justify-between text-neutral-500 mb-1">
            <span className="text-xs font-semibold uppercase tracking-wider">सामान र स्टक (Stock Search)</span>
            <div className="w-8 h-8 rounded-lg bg-purple-50 text-purple-700 flex items-center justify-center">
              <Package className="w-4 h-4" />
            </div>
          </div>
          <div className="text-base font-bold font-serif text-neutral-900 flex items-center gap-2">
            <span>[F10] स्टक जाँच गर्नुहोस्</span>
          </div>
          <div className="mt-2 text-xs text-neutral-500">
            <Link to="/inventory/items" className="text-primary-700 hover:underline font-semibold">
              सामानको मूल्य तथा मौज्दात हेर्नुहोस् →
            </Link>
          </div>
        </div>
      </div>

      {/* Recent Invoices Table */}
      <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-xs space-y-4">
        <div className="flex items-center justify-between pb-3 border-b border-neutral-200">
          <div>
            <h2 className="text-lg font-serif font-bold text-neutral-900 flex items-center gap-2">
              <Receipt className="w-5 h-5 text-primary-700" />
              <span>हालसालै जारी गरिएका बिक्री बिलहरू (Recent Sales Invoices)</span>
            </h2>
            <p className="text-xs text-neutral-600 mt-0.5">
              काउन्टरबाट प्रिन्ट गर्न वा रसिद हेर्न कुनै पनि बिलमा क्लिक गर्नुहोस्
            </p>
          </div>
          <Link
            to="/invoices"
            className="text-xs font-semibold text-primary-700 hover:underline flex items-center gap-1"
          >
            <span>सबै बिलहरू हेर्नुहोस्</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </Link>
        </div>

        <div className="overflow-x-auto border border-neutral-200 rounded-lg">
          <table className="w-full text-left text-xs">
            <thead className="bg-neutral-50 text-neutral-700 font-semibold border-b border-neutral-200 uppercase tracking-wider text-[11px]">
              <tr>
                <th className="py-2.5 px-3">बिल नं (Invoice No)</th>
                <th className="py-2.5 px-3">ग्राहकको नाम (Customer)</th>
                <th className="py-2.5 px-3">मिति (Date)</th>
                <th className="py-2.5 px-3 text-right">कुल रकम (Grand Total)</th>
                <th className="py-2.5 px-3">स्थिति</th>
                <th className="py-2.5 px-3 text-right">कार्य</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-neutral-200">
              {isLoading ? (
                <tr>
                  <td colSpan={6} className="py-6 text-center text-neutral-500 font-serif">
                    बिलहरू लोड हुँदैछन्...
                  </td>
                </tr>
              ) : invoices.length === 0 ? (
                <tr>
                  <td colSpan={6} className="py-8 text-center text-neutral-500 font-serif">
                    अहिले कुनै पनि बिल जारी गरिएको छैन। माथिको <strong>"[F8] नयाँ बिक्री बिल"</strong> बाट पहिलो बिल जारी गर्नुहोस्।
                  </td>
                </tr>
              ) : (
                invoices.slice(0, 8).map((inv) => (
                  <tr key={inv.id} className="hover:bg-neutral-50/50">
                    <td className="py-2.5 px-3 font-mono font-bold text-primary-800">
                      <Link to={`/invoices/${inv.id}`} className="hover:underline">
                        {inv.invoiceNumber}
                      </Link>
                    </td>
                    <td className="py-2.5 px-3 font-semibold text-neutral-900 font-serif">
                      {inv.customerName || 'नगद बिक्री (Walk-in Customer)'}
                    </td>
                    <td className="py-2.5 px-3 text-neutral-600 font-mono text-[11px]">
                      {inv.invoiceDate?.slice(0, 10)}
                    </td>
                    <td className="py-2.5 px-3 text-right font-mono font-bold text-neutral-900">
                      {formatMoney(inv.totalAmount)}
                    </td>
                    <td className="py-2.5 px-3">
                      <span className="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-50 text-emerald-800 border border-emerald-200">
                        {inv.status}
                      </span>
                    </td>
                    <td className="py-2.5 px-3 text-right">
                      <Link
                        to={`/invoices/${inv.id}`}
                        className="inline-flex items-center gap-1 text-xs font-semibold text-neutral-700 hover:text-primary-800 bg-neutral-100 hover:bg-neutral-200 px-2 py-1 rounded transition-colors"
                      >
                        <Printer className="w-3 h-3" />
                        <span>हेर्नुहोस् / प्रिन्ट</span>
                      </Link>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
