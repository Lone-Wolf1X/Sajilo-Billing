import React, { useState } from 'react';
import {
  Coins,
  Building,
  CreditCard,
  Scale,
  ArrowRight,
  ArrowLeft,
  Sparkles,
  HelpCircle,
  Calculator,
} from 'lucide-react';
import { useOpeningBalance, usePostOpeningBalance } from '../../hooks/useSetup';
import { OpeningBalanceSummary } from './OpeningBalanceSummary';
import { BalanceIndicator } from './BalanceIndicator';
import { formatMoney } from '../../lib/invoiceUtils';

interface Props {
  onBack?: () => void;
  onContinue?: () => void;
}

export const OpeningBalancesStep: React.FC<Props> = ({ onBack, onContinue }) => {
  const { data: existing, isLoading, refetch } = useOpeningBalance();
  const postMutation = usePostOpeningBalance();

  // If already posted, show summary and allow reversible reset
  const isPosted = existing?.posted === true;

  // Fiscal year start / Opening Date
  const defaultDate = () => {
    const today = new Date();
    // Default Nepal fiscal year starts around July 16/17 (Shrawan 1)
    const year = today.getMonth() >= 6 ? today.getFullYear() : today.getFullYear() - 1;
    return `${year}-07-17`;
  };

  const [openingDate, setOpeningDate] = useState(defaultDate());

  // Asset States
  const [cashInHand, setCashInHand] = useState('');
  const [bankBalance, setBankBalance] = useState('');
  const [accountsReceivable, setAccountsReceivable] = useState('');
  const [fixedAssets, setFixedAssets] = useState('');
  const [investments, setInvestments] = useState('');
  const [otherAssets, setOtherAssets] = useState('');

  // Liability States
  const [accountsPayable, setAccountsPayable] = useState('');
  const [bankLoans, setBankLoans] = useState('');
  const [otherLiabilities, setOtherLiabilities] = useState('');

  // Equity States
  const [retainedEarnings, setRetainedEarnings] = useState('');
  const [autoCapital, setAutoCapital] = useState(true);
  const [manualCapital, setManualCapital] = useState('');

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[40vh]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600 mx-auto mb-3" />
          <p className="text-sm text-neutral-500 font-serif">
            प्रारम्भिक मौज्दात विवरण लोड हुँदैछ... (Loading Opening Balances...)
          </p>
        </div>
      </div>
    );
  }

  if (isPosted && existing) {
    return (
      <OpeningBalanceSummary
        balance={existing}
        onContinue={onContinue}
        onReset={() => refetch()}
      />
    );
  }

  // Parse helper
  const parse = (val: string) => {
    if (!val) return 0;
    const clean = val.replace(/,/g, '').trim();
    const num = parseFloat(clean);
    return isNaN(num) ? 0 : num;
  };

  // Calculations
  const totalAssets =
    parse(cashInHand) +
    parse(bankBalance) +
    parse(accountsReceivable) +
    parse(fixedAssets) +
    parse(investments) +
    parse(otherAssets);

  const totalLiabilities =
    parse(accountsPayable) +
    parse(bankLoans) +
    parse(otherLiabilities);

  const parsedRetained = parse(retainedEarnings);

  // Auto-calculated capital: Assets - Liabilities - Retained Earnings
  const computedCapital = Math.max(0, totalAssets - totalLiabilities - parsedRetained);
  const activeCapital = autoCapital ? computedCapital : parse(manualCapital);

  const totalEquity = activeCapital + parsedRetained;
  const totalCredits = totalLiabilities + totalEquity;

  const diff = totalAssets - totalCredits;
  const isBalanced = Math.abs(diff) < 0.01;
  const canSubmit = totalAssets > 0 && isBalanced && !postMutation.isPending;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!canSubmit) return;

    const payload = {
      openingDate,
      cashInHand: cashInHand.trim() || undefined,
      bankBalance: bankBalance.trim() || undefined,
      accountsReceivable: accountsReceivable.trim() || undefined,
      fixedAssets: fixedAssets.trim() || undefined,
      investments: investments.trim() || undefined,
      otherAssets: otherAssets.trim() || undefined,
      accountsPayable: accountsPayable.trim() || undefined,
      bankLoans: bankLoans.trim() || undefined,
      otherLiabilities: otherLiabilities.trim() || undefined,
      capital: autoCapital ? computedCapital.toFixed(2) : manualCapital.trim() || undefined,
      retainedEarnings: retainedEarnings.trim() || undefined,
    };

    try {
      await postMutation.mutateAsync(payload);
    } catch {
      // Error handled by hook toast
    }
  };

  const renderNumberInput = (
    label: string,
    subLabel: string,
    value: string,
    onChange: (val: string) => void,
    placeholder = '0.00'
  ) => {
    const num = parse(value);
    return (
      <div>
        <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
          {label}
        </label>
        <div className="relative">
          <input
            type="text"
            inputMode="decimal"
            value={value}
            onChange={(e) => onChange(e.target.value)}
            placeholder={placeholder}
            className="w-full px-3 py-2 text-sm font-mono border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
          />
          {num > 0 && (
            <div className="text-[11px] font-mono text-neutral-500 mt-0.5 text-right">
              {formatMoney(num.toFixed(2))}
            </div>
          )}
        </div>
        <p className="text-[11px] text-neutral-500 mt-0.5">{subLabel}</p>
      </div>
    );
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {/* Introduction Card */}
      <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded bg-blue-50 dark:bg-blue-950/40 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800 text-xs font-semibold mb-1">
              <Scale className="w-3.5 h-3.5" />
              <span>दोहोरो लेखा प्रणाली (Double Entry Balance)</span>
            </div>
            <h2 className="text-xl font-serif font-bold text-neutral-900 dark:text-neutral-100">
              प्रारम्भिक मौज्दात प्रविष्टि (Phase 2: Opening Balances)
            </h2>
            <p className="text-xs text-neutral-600 dark:text-neutral-400 mt-1">
              आर्थिक वर्षको सुरुमा तपाईंको व्यापारको नगद, बैंक, सम्पत्ति र दायित्वको विवरण भर्नुहोस्। यसले खाता सुरु गर्न <strong>OPENING</strong> भौचर सिर्जना गर्दछ।
            </p>
          </div>

          <div className="flex flex-col items-start sm:items-end gap-1.5">
            <label className="text-xs font-semibold text-neutral-700 dark:text-neutral-300">
              प्रारम्भिक मिति (Opening Date) <span className="text-rose-600">*</span>
            </label>
            <input
              type="date"
              value={openingDate}
              onChange={(e) => setOpeningDate(e.target.value)}
              required
              className="px-3 py-1.5 text-sm font-mono border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
            />
          </div>
        </div>
      </div>

      {/* Grid: Assets (Left) vs Liabilities & Equity (Right) */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Assets Section (Debits) */}
        <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm space-y-4">
          <div className="flex items-center justify-between border-b border-neutral-200 dark:border-neutral-800 pb-3">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-md bg-emerald-50 dark:bg-emerald-950/50 border border-emerald-200 dark:border-emerald-800 flex items-center justify-center text-emerald-700 dark:text-emerald-300">
                <Coins className="w-4 h-4" />
              </div>
              <div>
                <h3 className="font-serif font-bold text-base text-neutral-900 dark:text-neutral-100">
                  सम्पत्ति विवरण (Assets - Debit)
                </h3>
                <p className="text-[11px] text-neutral-500">
                  व्यापारको स्वामित्वमा रहेका चल/अचल सम्पत्तिहरू
                </p>
              </div>
            </div>
            <div className="text-right">
              <div className="text-[10px] text-neutral-500 font-semibold uppercase">कुल सम्पत्ति</div>
              <div className="font-mono text-sm font-bold text-emerald-700 dark:text-emerald-400">
                {formatMoney(totalAssets.toFixed(2))}
              </div>
            </div>
          </div>

          <div className="space-y-3.5">
            {renderNumberInput(
              'नगद मौज्दात (Cash in Hand)',
              'दराज वा काउन्टरमा रहेको खुद नगद रकम',
              cashInHand,
              setCashInHand
            )}

            {renderNumberInput(
              'बैंक मौज्दात (Bank Balance)',
              'सबै बैंक खाताहरूमा जम्मा रहेको सुरुवाती मौज्दात',
              bankBalance,
              setBankBalance
            )}

            {renderNumberInput(
              'उठ्न बाँकी हिसाब (Accounts Receivable)',
              'ग्राहकहरूबाट लिन बाँकी कुल बक्यौता रकम',
              accountsReceivable,
              setAccountsReceivable
            )}

            {renderNumberInput(
              'स्थिर सम्पत्ति (Fixed Assets)',
              'जग्गा, भवन, फर्निचर, गाडी, कम्प्युटर आदि',
              fixedAssets,
              setFixedAssets
            )}

            {renderNumberInput(
              'लगानी (Investments)',
              'मुद्दती निक्षेप, सेयर वा अन्य दीर्घकालीन लगानी',
              investments,
              setInvestments
            )}

            {renderNumberInput(
              'अन्य चालू/अचल सम्पत्ति (Other Assets)',
              'पेस्की, डिपोजिट वा अन्य सुरुआती सम्पत्ति',
              otherAssets,
              setOtherAssets
            )}
          </div>
        </div>

        {/* Liabilities & Equity Section (Credits) */}
        <div className="space-y-6">
          {/* Liabilities Section */}
          <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between border-b border-neutral-200 dark:border-neutral-800 pb-3">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-md bg-rose-50 dark:bg-rose-950/50 border border-rose-200 dark:border-rose-800 flex items-center justify-center text-rose-700 dark:text-rose-300">
                  <CreditCard className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="font-serif font-bold text-base text-neutral-900 dark:text-neutral-100">
                    दायित्व विवरण (Liabilities - Credit)
                  </h3>
                  <p className="text-[11px] text-neutral-500">
                    साहु वा बैंकलाई बुझाउन बाँकी रकमहरू
                  </p>
                </div>
              </div>
              <div className="text-right">
                <div className="text-[10px] text-neutral-500 font-semibold uppercase">कुल दायित्व</div>
                <div className="font-mono text-sm font-bold text-rose-700 dark:text-rose-400">
                  {formatMoney(totalLiabilities.toFixed(2))}
                </div>
              </div>
            </div>

            <div className="space-y-3.5">
              {renderNumberInput(
                'तिर्न बाँकी साहु हिसाब (Accounts Payable)',
                'आपूर्तिकर्ता (Vendor) हरूलाई तिर्न बाँकी रकम',
                accountsPayable,
                setAccountsPayable
              )}

              {renderNumberInput(
                'बैंक ऋण / कर्जा (Bank Loans)',
                'ओभरड्राफ्ट, टर्म लोन वा अन्य बैंक कर्जा',
                bankLoans,
                setBankLoans
              )}

              {renderNumberInput(
                'अन्य दायित्व (Other Liabilities)',
                'तिर्न बाँकी तलब, घरभाडा वा कर दायित्व',
                otherLiabilities,
                setOtherLiabilities
              )}
            </div>
          </div>

          {/* Equity / Capital Section */}
          <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between border-b border-neutral-200 dark:border-neutral-800 pb-3">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-md bg-blue-50 dark:bg-blue-950/50 border border-blue-200 dark:border-blue-800 flex items-center justify-center text-blue-700 dark:text-blue-300">
                  <Building className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="font-serif font-bold text-base text-neutral-900 dark:text-neutral-100">
                    पुँजी तथा संचित कोष (Equity - Credit)
                  </h3>
                  <p className="text-[11px] text-neutral-500">
                    मालिकको लगानी तथा अघिल्ला वर्षको संचित नाफा
                  </p>
                </div>
              </div>
              <div className="text-right">
                <div className="text-[10px] text-neutral-500 font-semibold uppercase">कुल पुँजी</div>
                <div className="font-mono text-sm font-bold text-blue-700 dark:text-blue-400">
                  {formatMoney(totalEquity.toFixed(2))}
                </div>
              </div>
            </div>

            <div className="space-y-3.5">
              {renderNumberInput(
                'संचित नाफा / कोष (Retained Earnings)',
                'अघिल्ला वर्षहरूको बाँकी खुद नाफा वा कोष (छ भने)',
                retainedEarnings,
                setRetainedEarnings
              )}

              {/* Auto Capital Calculation Box */}
              <div className="p-3.5 bg-neutral-50 dark:bg-neutral-800/40 rounded border border-neutral-200 dark:border-neutral-700 space-y-2">
                <div className="flex items-center justify-between">
                  <label className="text-xs font-semibold text-neutral-800 dark:text-neutral-200 flex items-center gap-1.5 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={autoCapital}
                      onChange={(e) => setAutoCapital(e.target.checked)}
                      className="w-4 h-4 rounded text-primary-600 focus:ring-primary-500"
                    />
                    <span>स्वतः पुँजी गणना गर्नुहोस् (Auto-balance Owner's Capital)</span>
                  </label>
                  <span className="text-[11px] text-primary-700 dark:text-primary-300 font-semibold inline-flex items-center gap-1">
                    <Calculator className="w-3.5 h-3.5" />
                    Capital = Assets - Liabilities
                  </span>
                </div>

                {autoCapital ? (
                  <div className="flex items-center justify-between p-2.5 bg-white dark:bg-neutral-900 rounded border border-neutral-200 dark:border-neutral-700 font-mono text-sm">
                    <span className="text-neutral-600 dark:text-neutral-400 text-xs">
                      मालिकको चुक्ता पुँजी (Owner's Capital):
                    </span>
                    <span className="font-bold text-primary-700 dark:text-primary-300">
                      {formatMoney(computedCapital.toFixed(2))}
                    </span>
                  </div>
                ) : (
                  <div>
                    <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                      मालिकको पुँजी म्यानुअल प्रविष्टि (Manual Capital Amount)
                    </label>
                    <input
                      type="text"
                      inputMode="decimal"
                      value={manualCapital}
                      onChange={(e) => setManualCapital(e.target.value)}
                      placeholder="0.00"
                      className="w-full px-3 py-2 text-sm font-mono border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
                    />
                  </div>
                )}
                <p className="text-[11px] text-neutral-500">
                  {autoCapital
                    ? 'सम्पत्ति र दायित्वको अन्तर अनुसार पुँजी आफै हिसाब हुन्छ, जसले गर्दा लेजर शतप्रतिशत सन्तुलित रहन्छ।'
                    : 'तपाईं आफै पुँजी राख्न सक्नुहुन्छ। तर सम्पत्ति = दायित्व + पुँजी सन्तुलन मिल्नै पर्छ।'}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Live Balance Summary Bar */}
      <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-4 shadow-sm flex flex-col md:flex-row items-center justify-between gap-4">
        <BalanceIndicator totalDebits={totalAssets} totalCredits={totalCredits} />

        <div className="text-xs text-neutral-500 flex items-center gap-2">
          <HelpCircle className="w-4 h-4 text-neutral-400" />
          <span>
            आवश्यक परे पछि जुनसुकै बेला <strong>Reversal</strong> मार्फत सच्याउन सकिन्छ।
          </span>
        </div>
      </div>

      {/* Action Buttons Bar */}
      <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm">
        <div className="flex items-center gap-3 w-full sm:w-auto">
          {onBack && (
            <button
              type="button"
              onClick={onBack}
              className="inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-700 dark:text-neutral-300 hover:bg-neutral-100 dark:hover:bg-neutral-800 rounded border border-neutral-300 dark:border-neutral-700 transition-colors"
            >
              <ArrowLeft className="w-4 h-4" />
              <span>पछाडि फर्कनुहोस् (Back to Profile)</span>
            </button>
          )}

          {onContinue && (
            <button
              type="button"
              onClick={onContinue}
              className="px-4 py-2 text-sm font-semibold text-neutral-600 dark:text-neutral-400 hover:text-neutral-900 dark:hover:text-neutral-100 transition-colors"
            >
              अहिलेलाई छोड्नुहोस् (Skip for now)
            </button>
          )}
        </div>

        <button
          type="submit"
          disabled={!canSubmit}
          className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-2.5 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow-sm transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {postMutation.isPending ? (
            <span>प्रविष्टि गर्दैछ... (Posting...)</span>
          ) : (
            <>
              <Sparkles className="w-4 h-4" />
              <span>प्रारम्भिक मौज्दात दर्ता गर्नुहोस् (Post Opening Balances)</span>
              <ArrowRight className="w-4 h-4" />
            </>
          )}
        </button>
      </div>
    </form>
  );
};

