import React from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { UtilityBar } from './UtilityBar';
import { MainNav } from './MainNav';
import { FunctionKeysBar } from './FunctionKeysBar';
import { Footer } from './Footer';
import { useSetupStatus } from '../../hooks/useSetup';
import { AlertCircle, ArrowRight } from 'lucide-react';

export const AppLayout: React.FC = () => {
  const location = useLocation();
  const { data: setupStatus } = useSetupStatus();

  const showSetupBanner =
    setupStatus && !setupStatus.setupCompleted && location.pathname !== '/setup';

  return (
    <div className="flex flex-col min-h-screen bg-paper text-paper-text">
      <UtilityBar />
      <MainNav />
      <FunctionKeysBar />

      <main className="flex-1 max-w-[1400px] w-full mx-auto p-4 md:p-6">
        {showSetupBanner && (
          <div className="mb-5 bg-amber-50 border border-amber-300 rounded-md p-3.5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 shadow-sm animate-fadeIn">
            <div className="flex items-center gap-2.5 text-black text-xs sm:text-sm">
              <AlertCircle className="w-5 h-5 text-amber-600 flex-shrink-0" />
              <div>
                <span className="font-bold font-serif text-black">
                  कम्पनी प्रोफाइल सेटअप अधुरो छ (Business Profile Incomplete):
                </span>{' '}
                <span className="text-black font-semibold">
                  कर विजक (Tax Invoices), भ्याट विवरण र आधिकारिक लेजरका लागि नेपाल सरकारको मापदण्ड अनुसार विवरण पूरा गर्नुहोस्।
                </span>
              </div>
            </div>
            <Link
              to="/setup"
              className="inline-flex items-center gap-1.5 px-3.5 py-1.5 bg-amber-700 hover:bg-amber-800 active:bg-amber-900 text-white font-semibold rounded text-xs whitespace-nowrap shadow-sm transition-colors"
            >
              <span>अहिले सेटअप गर्नुहोस् (Setup Now)</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </Link>
          </div>
        )}

        <Outlet />
      </main>
      <Footer />
    </div>
  );
};
