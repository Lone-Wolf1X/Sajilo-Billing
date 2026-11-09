import React from 'react';
import { Link } from 'react-router-dom';
import { ArrowLeft, BookOpen } from 'lucide-react';
import { JournalEntryForm } from '../../components/journal/JournalEntryForm';

export const JournalEntryFormPage: React.FC = () => {
  return (
    <div className="space-y-6">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 pb-4 border-b border-paper-border">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <Link
              to="/journal-entries"
              className="text-xs text-paper-muted hover:text-brand-navy flex items-center gap-1 font-medium transition-colors"
            >
              <ArrowLeft className="w-3.5 h-3.5" />
              <span>Journal Entries</span>
            </Link>
          </div>
          <div className="flex items-center gap-2.5">
            <h1 className="font-serif text-2xl font-bold text-brand-navy">
              New Journal Voucher [F7]
            </h1>
            <span className="text-xs font-mono font-semibold bg-brand-navy-light text-brand-navy px-2 py-0.5 rounded border border-brand-navy/20">
              Voucher Draft
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-1">
            Create and post double-entry vouchers directly to the General Ledger. Total Debits must equal Total Credits.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <Link
            to="/accounts"
            className="btn btn-secondary btn-sm"
          >
            <BookOpen className="w-3.5 h-3.5 mr-1 text-brand-navy" />
            <span>Chart of Accounts</span>
          </Link>
        </div>
      </div>

      <JournalEntryForm />
    </div>
  );
};
