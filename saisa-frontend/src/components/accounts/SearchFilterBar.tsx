import React from 'react';
import { Search, Plus } from 'lucide-react';
import { Input } from '../ui/input';
import { Button } from '../ui/button';
import type { AccountType } from '../../types/account';

const TYPES: Array<{ value: AccountType | 'ALL'; label: string }> = [
  { value: 'ALL', label: 'All Account Classifications' },
  { value: 'ASSET', label: 'Assets' },
  { value: 'LIABILITY', label: 'Liabilities' },
  { value: 'EQUITY', label: 'Equity' },
  { value: 'INCOME', label: 'Income / Revenue' },
  { value: 'EXPENSE', label: 'Expenses' },
];

interface Props {
  search: string;
  onSearchChange: (v: string) => void;
  typeFilter: AccountType | 'ALL';
  onTypeFilterChange: (v: AccountType | 'ALL') => void;
  onCreate: () => void;
}

export const SearchFilterBar: React.FC<Props> = ({
  search,
  onSearchChange,
  typeFilter,
  onTypeFilterChange,
  onCreate,
}) => {
  return (
    <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3 mb-5">
      <div className="flex flex-1 items-center gap-3">
        <div className="relative flex-1 max-w-sm">
          <Search className="w-3.5 h-3.5 absolute left-3 top-1/2 -translate-y-1/2 text-paper-muted" />
          <Input
            placeholder="Search by code (e.g. 1001) or name..."
            className="pl-8 text-xs h-9"
            value={search}
            onChange={(e) => onSearchChange(e.target.value)}
          />
        </div>

        <select
          className="form-select text-xs h-9 min-w-[180px] cursor-pointer"
          value={typeFilter}
          onChange={(e) =>
            onTypeFilterChange(e.target.value as AccountType | 'ALL')
          }
        >
          {TYPES.map((t) => (
            <option key={t.value} value={t.value}>
              {t.label}
            </option>
          ))}
        </select>
      </div>

      <Button
        variant="primary"
        size="md"
        onClick={onCreate}
        className="whitespace-nowrap cursor-pointer"
      >
        <Plus className="w-4 h-4 mr-1" />
        <span>New Account</span>
      </Button>
    </div>
  );
};
