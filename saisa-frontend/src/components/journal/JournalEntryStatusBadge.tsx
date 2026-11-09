import React from 'react';
import type { EntryStatus } from '../../types/journalEntry';

const STYLES: Record<EntryStatus, { bg: string; text: string; label: string }> = {
  DRAFT: {
    bg: 'bg-amber-50',
    text: 'text-amber-800 border-amber-200',
    label: 'Draft',
  },
  POSTED: {
    bg: 'bg-emerald-50',
    text: 'text-emerald-800 border-emerald-200',
    label: 'Posted',
  },
  REVERSED: {
    bg: 'bg-slate-100',
    text: 'text-slate-700 border-slate-300',
    label: 'Reversed',
  },
};

export const JournalEntryStatusBadge: React.FC<{ status: EntryStatus }> = ({
  status,
}) => {
  const s = STYLES[status] || STYLES.DRAFT;
  return (
    <span
      className={`inline-block text-[10px] uppercase tracking-wider font-semibold px-2 py-0.5 rounded border ${s.bg} ${s.text}`}
    >
      {s.label}
    </span>
  );
};

