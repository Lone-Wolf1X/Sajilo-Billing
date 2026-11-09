import React, { useState } from 'react';
import {
  CheckCircle2,
  RotateCcw,
  ArrowRight,
  FileText,
  Calendar,
  Scale,
  ShieldCheck,
  AlertTriangle,
} from 'lucide-react';
import type { OpeningBalanceResponse } from '../../types/setup';
import { formatMoney } from '../../lib/invoiceUtils';
import { useResetOpeningBalance } from '../../hooks/useSetup';
import { Dialog } from '../ui/dialog';

interface Props {
  balance: OpeningBalanceResponse;
  onContinue?: () => void;
  onReset?: () => void;
}

export const OpeningBalanceSummary: React.FC<Props> = ({
  balance,
  onContinue,
  onReset,
}) => {
  const [showResetDialog, setShowResetDialog] = useState(false);
  const [resetReason, setResetReason] = useState('');
  const resetMutation = useResetOpeningBalance();

  const handleConfirmReset = async () => {
    if (resetReason.trim().length < 5) return;
    try {
      await resetMutation.mutateAsync(resetReason.trim());
      setShowResetDialog(false);
      setResetReason('');
      onReset?.();
    } catch {
      // Error handled by hook toast
    }
  };

  return (
    <div className="space-y-6">
      {/* Success Card */}
      <div className="bg-white dark:bg-neutral-900 border border-emerald-300 dark:border-emerald-800 rounded-lg p-6 shadow-sm">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-neutral-200 dark:border-neutral-800 pb-5">
          <div className="flex items-start gap-3">
            <div className="w-10 h-10 rounded-full bg-emerald-100 dark:bg-emerald-950/60 border border-emerald-300 dark:border-emerald-700 flex items-center justify-center text-emerald-600 dark:text-emerald-400 flex-shrink-0">
              <CheckCircle2 className="w-5 h-5" />
            </div>
            <div>
              <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800 text-xs font-semibold mb-1">
                <ShieldCheck className="w-3.5 h-3.5" />
                <span>सफलतापूर्वक लेजरमा प्रविष्टि गरिएको (Posted to Ledger)</span>
              </div>
              <h2 className="text-xl font-serif font-bold text-neutral-900 dark:text-neutral-100">
                प्रारम्भिक मौज्दात दर्ता भइसकेको छ (Opening Balances Active)
              </h2>
              <p className="text-xs text-neutral-600 dark:text-neutral-400 mt-1">
                कम्पनीको सुरुआती वित्तीय स्थिति लेजर तथा वासलातमा सुरक्षित गरिएको छ।
              </p>
            </div>
          </div>

          <div className="text-right">
            <div className="text-xs text-neutral-500 uppercase tracking-wider font-semibold">
              भौचर नम्बर (Voucher No.)
            </div>
            <div className="font-mono text-base font-bold text-primary-700 dark:text-primary-300 flex items-center gap-1 justify-end">
              <FileText className="w-4 h-4" />
              <span>{balance.journalEntryNumber || 'OPENING'}</span>
            </div>
          </div>
        </div>

        {/* Metrics Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 py-5 border-b border-neutral-200 dark:border-neutral-800">
          <div className="p-3.5 bg-neutral-50 dark:bg-neutral-800/40 rounded border border-neutral-200 dark:border-neutral-800">
            <div className="flex items-center gap-1.5 text-xs text-neutral-500 mb-1">
              <Calendar className="w-3.5 h-3.5" />
              <span>प्रारम्भिक मिति (Date)</span>
            </div>
            <div className="font-mono text-sm font-semibold text-neutral-800 dark:text-neutral-200">
              {balance.openingDate || '—'}
            </div>
          </div>

          <div className="p-3.5 bg-neutral-50 dark:bg-neutral-800/40 rounded border border-neutral-200 dark:border-neutral-800">
            <div className="text-xs text-neutral-500 mb-1">
              कुल सम्पत्ति (Total Assets - Dr)
            </div>
            <div className="font-mono text-sm font-bold text-emerald-700 dark:text-emerald-400">
              {formatMoney(balance.totalAssets || balance.totalDebits)}
            </div>
          </div>

          <div className="p-3.5 bg-neutral-50 dark:bg-neutral-800/40 rounded border border-neutral-200 dark:border-neutral-800">
            <div className="text-xs text-neutral-500 mb-1">
              कुल दायित्व (Total Liabilities - Cr)
            </div>
            <div className="font-mono text-sm font-bold text-rose-700 dark:text-rose-400">
              {formatMoney(balance.totalLiabilities)}
            </div>
          </div>

          <div className="p-3.5 bg-neutral-50 dark:bg-neutral-800/40 rounded border border-neutral-200 dark:border-neutral-800">
            <div className="text-xs text-neutral-500 mb-1">
              कुल पुँजी (Owner's Equity - Cr)
            </div>
            <div className="font-mono text-sm font-bold text-blue-700 dark:text-blue-400">
              {formatMoney(balance.totalEquity)}
            </div>
          </div>
        </div>

        {/* Audit / Balance Equation Note */}
        <div className="pt-4 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 text-xs text-neutral-600 dark:text-neutral-400">
          <div className="flex items-center gap-2">
            <Scale className="w-4 h-4 text-emerald-600 flex-shrink-0" />
            <span>
              <strong>लेखा सन्तुलन नियम:</strong> सम्पत्ति ({formatMoney(balance.totalAssets || balance.totalDebits)}) = दायित्व + पुँजी ({formatMoney(balance.totalCredits)})
            </span>
          </div>
          <span className="text-[11px] font-mono text-neutral-500">
            Journal Entry ID: #{balance.journalEntryId}
          </span>
        </div>
      </div>

      {/* Action Bar */}
      <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm">
        <button
          type="button"
          onClick={() => setShowResetDialog(true)}
          className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-rose-700 dark:text-rose-300 hover:text-rose-800 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded border border-rose-300 dark:border-rose-800 transition-colors"
        >
          <RotateCcw className="w-4 h-4" />
          <span>पुनः सच्याउनुहोस् / रिसेट गर्नुहोस् (Edit / Reset Balances)</span>
        </button>

        <button
          type="button"
          onClick={onContinue}
          className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-2 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow-sm transition-colors"
        >
          <span>अर्को चरण: मौज्दात (Next: Inventory Setup)</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>

      {/* Reversible Reset Confirmation Dialog */}
      <Dialog
        open={showResetDialog}
        onClose={() => setShowResetDialog(false)}
        title="प्रारम्भिक मौज्दात उल्ट्याउनुहोस् (Reverse & Reset Opening Balances)"
        description="अडिट नियम अनुसार पूर्व प्रविष्टि उल्ट्याएर नयाँ विवरण भर्न दिइनेछ।"
      >
        <div className="space-y-4">
          <div className="flex items-start gap-3 p-3 rounded bg-amber-50 dark:bg-amber-950/40 border border-amber-200 dark:border-amber-900/60 text-amber-900 dark:text-amber-200 text-xs">
            <AlertTriangle className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-semibold mb-1">
                के तपाईं प्रारम्भिक मौज्दात सच्याउन चाहनुहुन्छ?
              </p>
              <p className="opacity-90 leading-relaxed">
                यस प्रक्रियाले साविकको भौचर ({balance.journalEntryNumber}) लाई सुरक्षित रूपमा <strong>उल्ट्याउने (Reversal Journal Entry)</strong> भौचर बनाउनेछ र तपाईंलाई फेरि प्रारम्भिक रकमहरू सम्पादन गर्न दिनेछ।
              </p>
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
              उल्ट्याउनुको कारण (Reason for reset / reversal) <span className="text-rose-600">*</span>
            </label>
            <textarea
              value={resetReason}
              onChange={(e) => setResetReason(e.target.value)}
              placeholder="उदाहरण: बैंक हिसाब मिलान गर्दा सुरुवाती रकम फरक परेकोले (e.g. Correcting bank opening balance mismatch)"
              rows={3}
              className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
            />
            <div className="text-[11px] text-neutral-500 mt-1 flex justify-between">
              <span>कम्तीमा ५ अक्षर अनिवार्य (Min. 5 characters required)</span>
              <span className={resetReason.trim().length >= 5 ? 'text-emerald-600' : 'text-neutral-400'}>
                {resetReason.trim().length}/5
              </span>
            </div>
          </div>

          <div className="flex items-center justify-end gap-3 pt-3 border-t border-neutral-200 dark:border-neutral-800">
            <button
              type="button"
              onClick={() => setShowResetDialog(false)}
              disabled={resetMutation.isPending}
              className="px-4 py-2 text-xs font-semibold text-neutral-600 dark:text-neutral-400 hover:bg-neutral-100 dark:hover:bg-neutral-800 rounded border border-neutral-300 dark:border-neutral-700"
            >
              रद्द गर्नुहोस् (Cancel)
            </button>
            <button
              type="button"
              onClick={handleConfirmReset}
              disabled={resetReason.trim().length < 5 || resetMutation.isPending}
              className="inline-flex items-center gap-2 px-4 py-2 text-xs font-semibold text-white bg-rose-600 hover:bg-rose-700 active:bg-rose-800 rounded disabled:opacity-50 transition-colors"
            >
              {resetMutation.isPending ? (
                <span>उल्ट्याउँदैछ... (Resetting...)</span>
              ) : (
                <>
                  <RotateCcw className="w-3.5 h-3.5" />
                  <span>प्रमाणित गरी रिसेट गर्नुहोस् (Confirm Reset)</span>
                </>
              )}
            </button>
          </div>
        </div>
      </Dialog>
    </div>
  );
};

