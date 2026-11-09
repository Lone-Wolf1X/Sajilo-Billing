import React from 'react';

export const Footer: React.FC = () => {
  return (
    <footer className="mt-auto bg-[#f5f2ea] border-t border-paper-border py-2.5 px-4 md:px-6 text-xs text-paper-muted flex flex-col sm:flex-row justify-between items-center gap-2">
      <div className="flex items-center gap-2">
        <span>SAISA Enterprise Accounting Core v1.0</span>
        <span>·</span>
        <span>Multi-Tenant</span>
        <span>·</span>
        <span className="font-serif">Double-Entry General Ledger</span>
      </div>
      <div className="flex items-center gap-2">
        <span>
          Session:{' '}
          <span className="text-ledger-green font-semibold">
            Authenticated (JWT Active)
          </span>
        </span>
        <span>·</span>
        <span>Node: Production-01</span>
        <span>·</span>
        <span className="text-paper-subtle">Audit Immutable</span>
      </div>
    </footer>
  );
};
