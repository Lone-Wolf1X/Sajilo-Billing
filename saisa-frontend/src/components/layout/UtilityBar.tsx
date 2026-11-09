import React from 'react';
import { useAuth } from '@/hooks/useAuth';

export const UtilityBar: React.FC = () => {
  const { user, logout } = useAuth();

  const tenantCode = user?.tenantCode || 'ACME-01';
  const username = user?.fullName || user?.username || 'Administrator';
  const role = user?.roles?.[0] || 'ADMIN';

  return (
    <div className="bg-[#142338] text-[#c5d5e8] text-xs py-1.5 px-4 md:px-6 flex flex-wrap justify-between items-center gap-2 border-b border-[#233a59]">
      <div className="flex items-center gap-2 flex-wrap">
        <span className="font-semibold text-white flex items-center gap-1">
          🏢 {user?.tenantCode ? `${user.tenantCode.toUpperCase()} Enterprise` : 'Acme Traders Pvt. Ltd.'}
        </span>
        <span className="text-[#3d5a80]">|</span>
        <span>
          Code:{' '}
          <code className="text-white bg-[#1e3a5f] border border-[#2e5687] px-1.5 py-0.5 rounded text-[11px] font-mono">
            {tenantCode}
          </code>
        </span>
        <span className="text-[#3d5a80]">|</span>
        <span>
          Financial Year: <strong className="text-white">2026-2027</strong>
        </span>
        <span className="text-[#3d5a80]">|</span>
        <span className="inline-flex items-center">
          Period: <strong className="text-white ml-1 mr-1.5">November 2026</strong>
          <span className="inline-block w-2 h-2 rounded-full bg-ledger-green mr-1" />
          <span className="text-[11px] text-green-300 font-medium">OPEN</span>
        </span>
      </div>

      <div className="flex items-center gap-2 flex-wrap text-[#a8c0db]">
        <span className="hidden sm:inline">
          Currency: <strong className="text-white">NPR / INR (₹)</strong>
        </span>
        <span className="text-[#3d5a80] hidden sm:inline">|</span>
        <span className="hidden md:inline">
          Last Backup:{' '}
          <span className="text-green-400 font-semibold">Today 11:29 AM ✓</span>
        </span>
        <span className="text-[#3d5a80] hidden md:inline">|</span>
        <span>
          User: <strong className="text-white">{username} ({role})</strong>
        </span>
        <button
          onClick={logout}
          className="ml-2 text-white hover:text-red-300 underline font-medium cursor-pointer transition-colors"
          title="Sign out of accounting system"
        >
          Logout
        </button>
      </div>
    </div>
  );
};

