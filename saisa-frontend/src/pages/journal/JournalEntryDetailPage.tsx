import React, { useState } from 'react';
import { Link, useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft, RotateCcw, CheckCircle, Calendar, Hash, FileText } from 'lucide-react';
import { toast } from 'sonner';
import { JournalEntryLinesDisplay } from '../../components/journal/JournalEntryLinesDisplay';
import { JournalEntryStatusBadge } from '../../components/journal/JournalEntryStatusBadge';
import { ReverseEntryDialog } from '../../components/journal/ReverseEntryDialog';
import { Button } from '../../components/ui/button';
import { Skeleton } from '../../components/ui/skeleton';
import {
  useJournalEntry,
  usePostJournalEntry,
} from '../../hooks/useJournalEntries';
import { useAccounts } from '../../hooks/useAccounts';

const fmtDate = (d: string) => {
  try {
    return new Date(d).toLocaleDateString('en-IN', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
    });
  } catch {
    return d;
  }
};

const fmtDateTime = (d: string) => {
  try {
    return new Date(d).toLocaleString('en-IN', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  } catch {
    return d;
  }
};

export const JournalEntryDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const entryId = Number(id);

  const { data: entry, isLoading, error } = useJournalEntry(entryId);
  const { accounts = [] } = useAccounts();
  const postMutation = usePostJournalEntry();

  const [showReverseDialog, setShowReverseDialog] = useState(false);

  const handlePost = async () => {
    try {
      await postMutation.mutateAsync(entryId);
      toast.success(`Voucher ${entry?.entryNumber} posted to General Ledger!`);
    } catch {
      // toast is handled in mutation hook
    }
  };

  if (isLoading) {
    return (
      <div className="space-y-4 p-4">
        <Skeleton className="h-20 w-full" />
        <Skeleton className="h-64 w-full" />
      </div>
    );
  }

  if (error || !entry) {
    return (
      <div className="card p-12 text-center max-w-lg mx-auto my-8 border-ledger-red/30 bg-ledger-red-light/20">
        <h2 className="font-serif font-bold text-lg text-ledger-red mb-1">
          Journal Voucher Not Found
        </h2>
        <p className="text-xs text-paper-muted mb-4">
          The requested voucher identifier #{id} does not exist or has been archived.
        </p>
        <Link
          to="/journal-entries"
          className="btn btn-secondary inline-flex items-center gap-1 text-xs"
        >
          <ArrowLeft className="w-3.5 h-3.5" />
          <span>Return to Journal Entries</span>
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header Bar */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 pb-4 border-b border-paper-border">
        <div>
          <Link
            to="/journal-entries"
            className="text-xs text-paper-muted hover:text-brand-navy flex items-center gap-1 mb-1 font-medium transition-colors"
          >
            <ArrowLeft className="w-3.5 h-3.5" />
            <span>Back to All Vouchers</span>
          </Link>
          <div className="flex items-center gap-3">
            <h1 className="font-serif text-2xl font-bold text-brand-navy font-mono">
              {entry.entryNumber}
            </h1>
            <JournalEntryStatusBadge status={entry.status} />
          </div>
        </div>

        <div className="flex items-center gap-2">
          {entry.status === 'DRAFT' && (
            <Button
              variant="primary"
              onClick={handlePost}
              isLoading={postMutation.isPending}
            >
              <CheckCircle className="w-4 h-4 mr-1" />
              <span>Post to General Ledger</span>
            </Button>
          )}

          {entry.status === 'POSTED' && (
            <Button
              variant="secondary"
              onClick={() => setShowReverseDialog(true)}
              className="text-brand-maroon hover:border-brand-maroon"
            >
              <RotateCcw className="w-4 h-4 mr-1" />
              <span>Reverse Voucher</span>
            </Button>
          )}
        </div>
      </div>

      {/* Metadata Card */}
      <div className="bg-paper-surface border border-paper-border rounded-lg p-5 shadow-subtle">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 text-xs">
          <div>
            <div className="text-[11px] text-paper-muted uppercase tracking-wider mb-1 flex items-center gap-1">
              <Calendar className="w-3.5 h-3.5" />
              <span>Posting Date</span>
            </div>
            <div className="font-mono font-medium text-paper-text text-sm">
              {fmtDate(entry.entryDate)}
            </div>
          </div>

          <div>
            <div className="text-[11px] text-paper-muted uppercase tracking-wider mb-1">
              Voucher Type
            </div>
            <div className="font-semibold uppercase text-brand-navy text-xs bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border inline-block">
              {entry.entryType}
            </div>
          </div>

          <div>
            <div className="text-[11px] text-paper-muted uppercase tracking-wider mb-1 flex items-center gap-1">
              <Hash className="w-3.5 h-3.5" />
              <span>Reference Document</span>
            </div>
            <div className="font-mono text-paper-text">
              {entry.referenceType
                ? `${entry.referenceType} #${entry.referenceId ?? ''}`
                : '— (Manual Voucher)'}
            </div>
          </div>

          <div>
            <div className="text-[11px] text-paper-muted uppercase tracking-wider mb-1">
              Ledger Post Timestamp
            </div>
            <div className="font-mono text-paper-text">
              {entry.postedAt ? fmtDateTime(entry.postedAt) : 'Not Posted (Draft)'}
            </div>
          </div>
        </div>

        <div className="mt-4 pt-4 border-t border-paper-border">
          <div className="text-[11px] text-paper-muted uppercase tracking-wider mb-1 flex items-center gap-1">
            <FileText className="w-3.5 h-3.5" />
            <span>Narration / Legal Memo</span>
          </div>
          <div className="text-sm text-paper-text italic font-serif">
            "{entry.description || 'No narration provided'}"
          </div>
        </div>

        {entry.reversalOfId && (
          <div className="mt-3 pt-3 border-t border-dashed border-paper-border flex items-center gap-2 text-xs">
            <span className="text-paper-muted">Reversal of original voucher:</span>
            <Link
              to={`/journal-entries/${entry.reversalOfId}`}
              className="text-brand-navy font-mono font-semibold underline hover:opacity-80"
            >
              Voucher #{entry.reversalOfId} →
            </Link>
          </div>
        )}
      </div>

      {/* Lines Section */}
      <div className="bg-paper-surface border border-paper-border rounded-lg p-5 shadow-subtle space-y-3">
        <h2 className="font-serif font-bold text-base text-brand-navy">
          Audited Voucher Lines
        </h2>
        <JournalEntryLinesDisplay lines={entry.lines} accounts={accounts} />
      </div>

      {/* Reverse Modal Dialog */}
      <ReverseEntryDialog
        entryId={entry.id}
        entryNumber={entry.entryNumber}
        open={showReverseDialog}
        onClose={() => setShowReverseDialog(false)}
        onSuccess={(reversalId) => {
          setShowReverseDialog(false);
          navigate(`/journal-entries/${reversalId}`);
        }}
      />
    </div>
  );
};
