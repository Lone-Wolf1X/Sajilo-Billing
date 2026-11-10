import React, { useState } from 'react';
import {
  FileSpreadsheet,
  Download,
  TrendingUp,
  TrendingDown,
  Sparkles,
} from 'lucide-react';
import { useD01SalesBook, useD02PurchaseBook, useIrdSummary } from '../../hooks/useIrd';
import { formatMoney } from '../../lib/invoiceUtils';

export const IrdTaxReportPage: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'SUMMARY' | 'D01_SALES' | 'D02_PURCHASE'>('SUMMARY');
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');

  const { data: summary } = useIrdSummary(fromDate || undefined, toDate || undefined);
  const { data: sales = [], isLoading: loadingSales } = useD01SalesBook(fromDate || undefined, toDate || undefined);
  const { data: purchases = [], isLoading: loadingPurchases } = useD02PurchaseBook(fromDate || undefined, toDate || undefined);

  // CSV Exporter for D-01
  const exportD01Csv = () => {
    const headers = [
      'मिति (Date AD)',
      'मिति (Date BS)',
      'बीजक नं. (Invoice No)',
      'खरिदकर्ताको नाम (Customer Name)',
      'खरिदकर्ताको प्यान (Customer PAN)',
      'जम्मा बिक्री (Total Amount)',
      'कर छुट रकम (Exempt)',
      'करयोग्य रकम (Taxable)',
      '१३% भ्याट (VAT Amount)',
      'निकासी बिक्री (Export)',
    ];

    const rows = sales.map((s) => [
      s.dateAd,
      s.dateBs,
      `"${s.invoiceNumber}"`,
      `"${s.customerName}"`,
      `"${s.customerPan}"`,
      s.totalAmount.toFixed(2),
      s.nonTaxableAmount.toFixed(2),
      s.taxableAmount.toFixed(2),
      s.vatAmount.toFixed(2),
      s.exportAmount.toFixed(2),
    ]);

    const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + [headers.join(','), ...rows.map((e) => e.join(','))].join('\n');
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', `IRD_D01_Sales_Register_${fromDate || 'all'}_to_${toDate || 'all'}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // CSV Exporter for D-02
  const exportD02Csv = () => {
    const headers = [
      'मिति (Date AD)',
      'मिति (Date BS)',
      'बीजक/प्रज्ञापन नं. (Bill No)',
      'आपूर्तिकर्ताको नाम (Supplier Name)',
      'आपूर्तिकर्ताको प्यान (Supplier PAN)',
      'जम्मा खरिद (Total Amount)',
      'कर छुट रकम (Exempt)',
      'करयोग्य रकम (Taxable)',
      '१३% भ्याट (VAT Amount)',
      'पैठारी खरिद (Import)',
    ];

    const rows = purchases.map((p) => [
      p.dateAd,
      p.dateBs,
      `"${p.invoiceNumber}"`,
      `"${p.supplierName}"`,
      `"${p.supplierPan}"`,
      p.totalAmount.toFixed(2),
      p.nonTaxableAmount.toFixed(2),
      p.taxableAmount.toFixed(2),
      p.vatAmount.toFixed(2),
      p.importAmount.toFixed(2),
    ]);

    const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + [headers.join(','), ...rows.map((e) => e.join(','))].join('\n');
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', `IRD_D02_Purchase_Register_${fromDate || 'all'}_to_${toDate || 'all'}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="space-y-6 max-w-7xl mx-auto p-4 md:p-6">
      {/* Header Bar */}
      <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="flex items-start gap-3">
          <div className="w-12 h-12 rounded-lg bg-blue-50 border border-blue-200 flex items-center justify-center text-blue-700 flex-shrink-0">
            <FileSpreadsheet className="w-6 h-6" />
          </div>
          <div>
            <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-blue-50 text-blue-800 border border-blue-200 text-xs font-semibold mb-1">
              <span>नेपाल सरकार • आन्तरिक राजस्व विभाग (IRD Nepal Annex 13)</span>
            </div>
            <h1 className="text-2xl font-serif font-bold text-neutral-900">
              भ्याट तथा कर विवरण (D-01 / D-02 Registers)
            </h1>
            <p className="text-xs text-neutral-600 mt-1">
              IRD पोर्टल (taxpayerportal.ird.gov.np) मा मासिक भ्याट रिटर्न दाखिला गर्न आवश्यक अनुसूची १३ बिक्री र खरिद खाता।
            </p>
          </div>
        </div>

        {/* Date Filters */}
        <div className="flex flex-wrap items-center gap-2.5 bg-neutral-50 p-2.5 rounded-lg border border-neutral-200">
          <div className="flex items-center gap-1.5">
            <span className="text-xs font-semibold text-neutral-700">देखि:</span>
            <input
              type="date"
              value={fromDate}
              onChange={(e) => setFromDate(e.target.value)}
              className="px-2 py-1 text-xs font-mono border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
            />
          </div>
          <div className="flex items-center gap-1.5">
            <span className="text-xs font-semibold text-neutral-700">सम्म:</span>
            <input
              type="date"
              value={toDate}
              onChange={(e) => setToDate(e.target.value)}
              className="px-2 py-1 text-xs font-mono border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
            />
          </div>
          {(fromDate || toDate) && (
            <button
              type="button"
              onClick={() => {
                setFromDate('');
                setToDate('');
              }}
              className="text-xs text-rose-600 hover:underline px-1 font-semibold"
            >
              रिसेट
            </button>
          )}
        </div>
      </div>

      {/* Tabs Bar */}
      <div className="bg-white border border-neutral-300 rounded-lg p-1.5 shadow-sm flex flex-wrap gap-2">
        <button
          type="button"
          onClick={() => setActiveTab('SUMMARY')}
          className={`flex-1 py-2.5 px-4 rounded-md text-xs font-bold transition-colors ${
            activeTab === 'SUMMARY'
              ? 'bg-primary-700 text-white shadow-sm'
              : 'text-neutral-700 hover:bg-neutral-100'
          }`}
        >
          १. कर विवरण सारांश (VAT Return Summary)
        </button>

        <button
          type="button"
          onClick={() => setActiveTab('D01_SALES')}
          className={`flex-1 py-2.5 px-4 rounded-md text-xs font-bold transition-colors ${
            activeTab === 'D01_SALES'
              ? 'bg-primary-700 text-white shadow-sm'
              : 'text-neutral-700 hover:bg-neutral-100'
          }`}
        >
          २. D-01 बिक्री खाता (Sales Book - Annex 13)
        </button>

        <button
          type="button"
          onClick={() => setActiveTab('D02_PURCHASE')}
          className={`flex-1 py-2.5 px-4 rounded-md text-xs font-bold transition-colors ${
            activeTab === 'D02_PURCHASE'
              ? 'bg-primary-700 text-white shadow-sm'
              : 'text-neutral-700 hover:bg-neutral-100'
          }`}
        >
          ३. D-02 खरिद खाता (Purchase Book - Annex 13)
        </button>
      </div>

      {/* ==================== TAB 1: SUMMARY ==================== */}
      {activeTab === 'SUMMARY' && (
        <div className="space-y-6">
          {/* Main Calculation Card */}
          <div className="bg-white border-2 border-primary-200 rounded-lg p-6 shadow-sm">
            <h2 className="text-base font-bold font-serif text-neutral-900 pb-3 border-b border-neutral-200 flex items-center justify-between">
              <span>मूल्य अभिवृद्धि कर (VAT) गणना सारांश</span>
              <span className="text-xs font-mono text-neutral-500 font-normal">
                बिक्री बीजक: {summary?.salesCount || 0} • खरिद बीजक: {summary?.purchaseCount || 0}
              </span>
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 my-6">
              {/* Sales VAT (Output) */}
              <div className="p-5 rounded-lg bg-emerald-50 border border-emerald-200 space-y-1">
                <div className="flex items-center gap-1.5 text-xs font-bold text-emerald-900 uppercase">
                  <TrendingUp className="w-4 h-4 text-emerald-600" />
                  <span>D-01 जम्मा बिक्री कर (Output VAT)</span>
                </div>
                <div className="font-mono text-2xl font-bold text-emerald-700">
                  {formatMoney(summary?.totalSalesVat?.toFixed(2) || '0.00')}
                </div>
                <p className="text-[11px] text-emerald-800">
                  करयोग्य बिक्री: {formatMoney(summary?.totalSalesTaxable?.toFixed(2) || '0.00')}
                </p>
              </div>

              {/* Purchase VAT (Input) */}
              <div className="p-5 rounded-lg bg-blue-50 border border-blue-200 space-y-1">
                <div className="flex items-center gap-1.5 text-xs font-bold text-blue-900 uppercase">
                  <TrendingDown className="w-4 h-4 text-blue-600" />
                  <span>D-02 जम्मा खरिद कर (Input VAT Credit)</span>
                </div>
                <div className="font-mono text-2xl font-bold text-blue-700">
                  {formatMoney(summary?.totalPurchaseVat?.toFixed(2) || '0.00')}
                </div>
                <p className="text-[11px] text-blue-800">
                  करयोग्य खरिद: {formatMoney(summary?.totalPurchaseTaxable?.toFixed(2) || '0.00')}
                </p>
              </div>

              {/* Net Payable / Credit */}
              <div
                className={`p-5 rounded-lg border space-y-1 ${
                  (summary?.netVatPayable || 0) >= 0
                    ? 'bg-amber-50 border-amber-300'
                    : 'bg-purple-50 border-purple-300'
                }`}
              >
                <div className="flex items-center gap-1.5 text-xs font-bold uppercase text-neutral-900">
                  <Sparkles className="w-4 h-4 text-primary-600" />
                  <span>
                    {(summary?.netVatPayable || 0) >= 0
                      ? 'खुद तिर्नुपर्ने भ्याट (Net VAT Payable)'
                      : 'खुद भ्याट फिर्ता / क्रेडिट (Net VAT Credit)'}
                  </span>
                </div>
                <div
                  className={`font-mono text-2xl font-bold ${
                    (summary?.netVatPayable || 0) >= 0 ? 'text-amber-800' : 'text-purple-700'
                  }`}
                >
                  {formatMoney(Math.abs(summary?.netVatPayable || 0).toFixed(2))}
                </div>
                <p className="text-[11px] text-neutral-600">
                  {(summary?.netVatPayable || 0) >= 0
                    ? 'बिक्री कर > खरिद कर (राजस्व खातामा दाखिला गर्नुपर्ने रकम)'
                    : 'खरिद कर > बिक्री कर (अर्को महिना सार्न मिल्ने कर क्रेडिट)'}
                </p>
              </div>
            </div>

            {/* IRD Portal Filing Instructions */}
            <div className="p-4 rounded-lg bg-neutral-50 border border-neutral-200 text-xs text-neutral-700 space-y-2">
              <p className="font-bold text-sm text-neutral-900">
                आन्तरिक राजस्व विभाग (IRD) पोर्टलमा दाखिला गर्ने विधि:
              </p>
              <ol className="list-decimal list-inside space-y-1 text-xs opacity-95">
                <li>
                  माथिको <strong>D-01 बिक्री खाता</strong> ट्याब खोल्नुहोस् र <strong>"Export CSV (IRD Portal Format)"</strong> डाउनलोड गर्नुहोस्।
                </li>
                <li>
                  त्यस्तै <strong>D-02 खरिद खाता</strong> ट्याब खोल्नुहोस् र खरिद खाताको CSV डाउनलोड गर्नुहोस्।
                </li>
                <li>
                  <strong>taxpayerportal.ird.gov.np</strong> मा आफ्नो प्यान र पासवर्डबाट लगइन गरी <strong>VAT Return</strong> फारममा यो विवरण प्रविष्टि गर्नुहोस्।
                </li>
              </ol>
            </div>
          </div>
        </div>
      )}

      {/* ==================== TAB 2: D-01 SALES BOOK ==================== */}
      {activeTab === 'D01_SALES' && (
        <div className="space-y-4 bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-3 border-b border-neutral-200">
            <div>
              <h2 className="text-base font-bold font-serif text-neutral-900">
                अनुसूची १३: बिक्री खाता (Sales Book - D-01)
              </h2>
              <p className="text-xs text-neutral-500">
                मूल्य अभिवृद्धि कर नियमावली, २०५३ को नियम २३ को उपनियम (१) सँग सम्बन्धित
              </p>
            </div>

            <button
              type="button"
              onClick={exportD01Csv}
              disabled={sales.length === 0}
              className="inline-flex items-center gap-1.5 px-4 py-2 text-xs font-bold text-white bg-primary-700 hover:bg-primary-800 rounded shadow-sm transition-colors disabled:opacity-50"
            >
              <Download className="w-3.5 h-3.5" />
              <span>Export CSV (IRD Portal Format)</span>
            </button>
          </div>

          <div className="overflow-x-auto border border-neutral-200 rounded-lg">
            <table className="w-full text-left text-xs">
              <thead className="bg-neutral-50 text-neutral-700 font-semibold border-b border-neutral-200 uppercase tracking-wider text-[11px]">
                <tr>
                  <th className="py-2.5 px-3">मिति (Date AD)</th>
                  <th className="py-2.5 px-3">मिति (BS)</th>
                  <th className="py-2.5 px-3">बीजक नं. (Invoice)</th>
                  <th className="py-2.5 px-3 min-w-[180px]">खरिदकर्ताको नाम (Buyer)</th>
                  <th className="py-2.5 px-3">प्यान नं. (PAN)</th>
                  <th className="py-2.5 px-3 text-right">जम्मा बिक्री</th>
                  <th className="py-2.5 px-3 text-right">कर छुट बिक्री</th>
                  <th className="py-2.5 px-3 text-right">करयोग्य बिक्री</th>
                  <th className="py-2.5 px-3 text-right text-emerald-700">१३% भ्याट (VAT)</th>
                  <th className="py-2.5 px-3 text-right">निकासी बिक्री</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-neutral-200">
                {loadingSales ? (
                  <tr>
                    <td colSpan={10} className="py-8 text-center text-neutral-500 font-serif">
                      बिक्री खाता लोड हुँदैछ...
                    </td>
                  </tr>
                ) : sales.length === 0 ? (
                  <tr>
                    <td colSpan={10} className="py-8 text-center text-neutral-500 font-serif">
                      कुनै बिक्री बीजक फेला परेन।
                    </td>
                  </tr>
                ) : (
                  sales.map((s) => (
                    <tr key={s.id} className="hover:bg-neutral-50/50">
                      <td className="py-2 px-3 font-mono text-neutral-600">{s.dateAd}</td>
                      <td className="py-2 px-3 font-mono text-neutral-800 font-semibold">{s.dateBs}</td>
                      <td className="py-2 px-3 font-mono font-bold text-primary-700">{s.invoiceNumber}</td>
                      <td className="py-2 px-3 font-medium text-neutral-900">{s.customerName}</td>
                      <td className="py-2 px-3 font-mono text-neutral-800">{s.customerPan}</td>
                      <td className="py-2 px-3 font-mono font-bold text-right">{formatMoney(s.totalAmount.toFixed(2))}</td>
                      <td className="py-2 px-3 font-mono text-right text-neutral-500">{formatMoney(s.nonTaxableAmount.toFixed(2))}</td>
                      <td className="py-2 px-3 font-mono text-right">{formatMoney(s.taxableAmount.toFixed(2))}</td>
                      <td className="py-2 px-3 font-mono font-bold text-right text-emerald-700">{formatMoney(s.vatAmount.toFixed(2))}</td>
                      <td className="py-2 px-3 font-mono text-right text-neutral-500">{formatMoney(s.exportAmount.toFixed(2))}</td>
                    </tr>
                  ))
                )}
              </tbody>
              {sales.length > 0 && (
                <tfoot className="bg-neutral-100 font-bold border-t-2 border-neutral-300 text-xs">
                  <tr>
                    <td colSpan={5} className="py-3 px-3 text-right font-serif">कुल जम्मा (Grand Total):</td>
                    <td className="py-3 px-3 font-mono text-right font-bold text-neutral-900">
                      {formatMoney(sales.reduce((sum, s) => sum + s.totalAmount, 0).toFixed(2))}
                    </td>
                    <td className="py-3 px-3 font-mono text-right text-neutral-600">
                      {formatMoney(sales.reduce((sum, s) => sum + s.nonTaxableAmount, 0).toFixed(2))}
                    </td>
                    <td className="py-3 px-3 font-mono text-right text-neutral-900">
                      {formatMoney(sales.reduce((sum, s) => sum + s.taxableAmount, 0).toFixed(2))}
                    </td>
                    <td className="py-3 px-3 font-mono text-right text-emerald-700">
                      {formatMoney(sales.reduce((sum, s) => sum + s.vatAmount, 0).toFixed(2))}
                    </td>
                    <td className="py-3 px-3 font-mono text-right text-neutral-600">
                      {formatMoney(sales.reduce((sum, s) => sum + s.exportAmount, 0).toFixed(2))}
                    </td>
                  </tr>
                </tfoot>
              )}
            </table>
          </div>
        </div>
      )}

      {/* ==================== TAB 3: D-02 PURCHASE BOOK ==================== */}
      {activeTab === 'D02_PURCHASE' && (
        <div className="space-y-4 bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-3 border-b border-neutral-200">
            <div>
              <h2 className="text-base font-bold font-serif text-neutral-900">
                अनुसूची १३: खरिद खाता (Purchase Book - D-02)
              </h2>
              <p className="text-xs text-neutral-500">
                मूल्य अभिवृद्धि कर नियमावली, २०५३ को नियम २३ को उपनियम (१) सँग सम्बन्धित
              </p>
            </div>

            <button
              type="button"
              onClick={exportD02Csv}
              disabled={purchases.length === 0}
              className="inline-flex items-center gap-1.5 px-4 py-2 text-xs font-bold text-white bg-primary-700 hover:bg-primary-800 rounded shadow-sm transition-colors disabled:opacity-50"
            >
              <Download className="w-3.5 h-3.5" />
              <span>Export CSV (IRD Portal Format)</span>
            </button>
          </div>

          <div className="overflow-x-auto border border-neutral-200 rounded-lg">
            <table className="w-full text-left text-xs">
              <thead className="bg-neutral-50 text-neutral-700 font-semibold border-b border-neutral-200 uppercase tracking-wider text-[11px]">
                <tr>
                  <th className="py-2.5 px-3">मिति (Date AD)</th>
                  <th className="py-2.5 px-3">मिति (BS)</th>
                  <th className="py-2.5 px-3">बीजक/प्रज्ञापन नं.</th>
                  <th className="py-2.5 px-3 min-w-[180px]">आपूर्तिकर्ताको नाम (Supplier)</th>
                  <th className="py-2.5 px-3">प्यान नं. (PAN)</th>
                  <th className="py-2.5 px-3 text-right">जम्मा खरिद</th>
                  <th className="py-2.5 px-3 text-right">कर छुट खरिद</th>
                  <th className="py-2.5 px-3 text-right">करयोग्य खरिद</th>
                  <th className="py-2.5 px-3 text-right text-blue-700">१३% भ्याट (VAT)</th>
                  <th className="py-2.5 px-3 text-right">पैठारी खरिद</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-neutral-200">
                {loadingPurchases ? (
                  <tr>
                    <td colSpan={10} className="py-8 text-center text-neutral-500 font-serif">
                      खरिद खाता लोड हुँदैछ...
                    </td>
                  </tr>
                ) : purchases.length === 0 ? (
                  <tr>
                    <td colSpan={10} className="py-8 text-center text-neutral-500 font-serif">
                      कुनै खरिद बीजक फेला परेन।
                    </td>
                  </tr>
                ) : (
                  purchases.map((p) => (
                    <tr key={p.id} className="hover:bg-neutral-50/50">
                      <td className="py-2 px-3 font-mono text-neutral-600">{p.dateAd}</td>
                      <td className="py-2 px-3 font-mono text-neutral-800 font-semibold">{p.dateBs}</td>
                      <td className="py-2 px-3 font-mono font-bold text-neutral-900">{p.invoiceNumber}</td>
                      <td className="py-2 px-3 font-medium text-neutral-900">{p.supplierName}</td>
                      <td className="py-2 px-3 font-mono text-neutral-800">{p.supplierPan}</td>
                      <td className="py-2 px-3 font-mono font-bold text-right">{formatMoney(p.totalAmount.toFixed(2))}</td>
                      <td className="py-2 px-3 font-mono text-right text-neutral-500">{formatMoney(p.nonTaxableAmount.toFixed(2))}</td>
                      <td className="py-2 px-3 font-mono text-right">{formatMoney(p.taxableAmount.toFixed(2))}</td>
                      <td className="py-2 px-3 font-mono font-bold text-right text-blue-700">{formatMoney(p.vatAmount.toFixed(2))}</td>
                      <td className="py-2 px-3 font-mono text-right text-neutral-500">{formatMoney(p.importAmount.toFixed(2))}</td>
                    </tr>
                  ))
                )}
              </tbody>
              {purchases.length > 0 && (
                <tfoot className="bg-neutral-100 font-bold border-t-2 border-neutral-300 text-xs">
                  <tr>
                    <td colSpan={5} className="py-3 px-3 text-right font-serif">कुल जम्मा (Grand Total):</td>
                    <td className="py-3 px-3 font-mono text-right font-bold text-neutral-900">
                      {formatMoney(purchases.reduce((sum, p) => sum + p.totalAmount, 0).toFixed(2))}
                    </td>
                    <td className="py-3 px-3 font-mono text-right text-neutral-600">
                      {formatMoney(purchases.reduce((sum, p) => sum + p.nonTaxableAmount, 0).toFixed(2))}
                    </td>
                    <td className="py-3 px-3 font-mono text-right text-neutral-900">
                      {formatMoney(purchases.reduce((sum, p) => sum + p.taxableAmount, 0).toFixed(2))}
                    </td>
                    <td className="py-3 px-3 font-mono text-right text-blue-700">
                      {formatMoney(purchases.reduce((sum, p) => sum + p.vatAmount, 0).toFixed(2))}
                    </td>
                    <td className="py-3 px-3 font-mono text-right text-neutral-600">
                      {formatMoney(purchases.reduce((sum, p) => sum + p.importAmount, 0).toFixed(2))}
                    </td>
                  </tr>
                </tfoot>
              )}
            </table>
          </div>
        </div>
      )}
    </div>
  );
};
