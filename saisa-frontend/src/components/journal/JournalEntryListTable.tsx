import React from 'react';
import { Link } from 'react-router-dom';
import { JournalEntryStatusBadge } from './JournalEntryStatusBadge';
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '../ui/table';
import type { JournalEntrySummary } from '../../types/journalEntry';

interface Props {
  entries: JournalEntrySummary[];
}

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

export const JournalEntryListTable: React.FC<Props> = ({ entries }) => {
  return (
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead className="w-36">Entry #</TableHead>
          <TableHead className="w-32">Posting Date</TableHead>
          <TableHead className="w-28">Type</TableHead>
          <TableHead>Voucher Narration / Memo</TableHead>
          <TableHead className="w-28 text-center">Status</TableHead>
          <TableHead className="w-24 text-right">Actions</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        {entries.map((e) => (
          <TableRow key={e.id} className="hover:bg-paper-hover/50">
            <TableCell>
              <Link
                to={`/journal-entries/${e.id}`}
                className="font-mono text-xs font-bold text-brand-navy hover:underline bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border inline-block"
              >
                {e.entryNumber}
              </Link>
            </TableCell>
            <TableCell className="text-xs font-mono">{fmtDate(e.entryDate)}</TableCell>
            <TableCell className="text-xs uppercase text-paper-muted font-medium">
              {e.entryType}
            </TableCell>
            <TableCell className="text-xs text-paper-text max-w-md truncate">
              {e.description || '—'}
            </TableCell>
            <TableCell className="text-center">
              <JournalEntryStatusBadge status={e.status} />
            </TableCell>
            <TableCell className="text-right">
              <Link
                to={`/journal-entries/${e.id}`}
                className="text-xs text-brand-navy hover:underline font-semibold"
              >
                View →
              </Link>
            </TableCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  );
};

