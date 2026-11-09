import * as React from 'react';
import { Search, ChevronDown, Check } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Badge } from './badge';

export interface ComboboxOption {
  value: number;
  code: string;
  label: string;
  type?: string;
}

export interface ComboboxProps {
  options: ComboboxOption[];
  value?: number;
  onChange: (val: number) => void;
  placeholder?: string;
  disabled?: boolean;
  error?: string;
  className?: string;
}

export const Combobox: React.FC<ComboboxProps> = ({
  options,
  value,
  onChange,
  placeholder = 'Select account...',
  disabled = false,
  error,
  className,
}) => {
  const [open, setOpen] = React.useState(false);
  const [query, setQuery] = React.useState('');
  const [highlightIndex, setHighlightIndex] = React.useState(0);
  const containerRef = React.useRef<HTMLDivElement>(null);
  const inputRef = React.useRef<HTMLInputElement>(null);

  const selectedOption = React.useMemo(
    () => options.find((o) => o.value === value),
    [options, value]
  );

  const filteredOptions = React.useMemo(() => {
    if (!query.trim()) return options.slice(0, 15);
    const q = query.toLowerCase();
    return options
      .filter(
        (o) =>
          o.code.toLowerCase().includes(q) ||
          o.label.toLowerCase().includes(q) ||
          (o.type && o.type.toLowerCase().includes(q))
      )
      .slice(0, 15);
  }, [options, query]);

  // Click outside listener
  React.useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (
        containerRef.current &&
        !containerRef.current.contains(e.target as Node)
      ) {
        setOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSelect = (val: number) => {
    onChange(val);
    setOpen(false);
    setQuery('');
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!open) {
      if (e.key === 'ArrowDown' || e.key === 'Enter') {
        setOpen(true);
        e.preventDefault();
      }
      return;
    }

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setHighlightIndex((prev) =>
        prev < filteredOptions.length - 1 ? prev + 1 : 0
      );
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setHighlightIndex((prev) =>
        prev > 0 ? prev - 1 : filteredOptions.length - 1
      );
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (filteredOptions[highlightIndex]) {
        handleSelect(filteredOptions[highlightIndex].value);
      }
    } else if (e.key === 'Escape') {
      setOpen(false);
    }
  };

  return (
    <div ref={containerRef} className={cn('relative w-full', className)}>
      {/* Trigger Button / Display */}
      <div
        onClick={() => {
          if (!disabled) {
            setOpen((prev) => !prev);
            setTimeout(() => inputRef.current?.focus(), 50);
          }
        }}
        onKeyDown={handleKeyDown}
        tabIndex={disabled ? -1 : 0}
        className={cn(
          'form-input flex items-center justify-between cursor-pointer select-none py-1.5 px-3 min-h-[36px]',
          disabled && 'opacity-50 cursor-not-allowed bg-paper-alt',
          error && 'border-ledger-red',
          open && 'border-brand-navy ring-2 ring-brand-navy/15'
        )}
      >
        {selectedOption ? (
          <div className="flex items-center gap-2 truncate">
            <code className="text-xs font-mono font-bold text-brand-navy bg-paper-alt px-1 py-0.5 rounded border border-paper-border">
              {selectedOption.code}
            </code>
            <span className="truncate text-paper-text text-sm">
              {selectedOption.label}
            </span>
            {selectedOption.type && (
              <Badge
                variant={
                  selectedOption.type.toLowerCase() as
                    | 'asset'
                    | 'liability'
                    | 'equity'
                    | 'income'
                    | 'expense'
                }
                className="text-[10px] px-1 py-0 hidden sm:inline-flex"
              >
                {selectedOption.type}
              </Badge>
            )}
          </div>
        ) : (
          <span className="text-paper-subtle text-sm">{placeholder}</span>
        )}

        <ChevronDown className="w-3.5 h-3.5 text-paper-muted flex-shrink-0 ml-1" />
      </div>

      {error && <p className="text-xs text-ledger-red mt-1">{error}</p>}

      {/* Dropdown Menu */}
      {open && (
        <div className="absolute top-full left-0 right-0 mt-1 bg-white border border-paper-border-strong rounded-md shadow-lg z-50 overflow-hidden animate-in fade-in-50 duration-100">
          {/* Search box inside dropdown */}
          <div className="p-2 border-b border-paper-border bg-paper-alt flex items-center gap-2">
            <Search className="w-3.5 h-3.5 text-paper-muted" />
            <input
              ref={inputRef}
              type="text"
              value={query}
              onChange={(e) => {
                setQuery(e.target.value);
                setHighlightIndex(0);
              }}
              onKeyDown={handleKeyDown}
              placeholder="Type code or account name..."
              className="w-full bg-transparent text-xs text-paper-text placeholder-paper-subtle focus:outline-none"
            />
          </div>

          {/* Options List */}
          <ul className="max-h-56 overflow-y-auto py-1">
            {filteredOptions.length === 0 ? (
              <li className="px-3 py-2 text-xs text-paper-muted italic text-center">
                No matching accounts found
              </li>
            ) : (
              filteredOptions.map((opt, idx) => {
                const isSelected = opt.value === value;
                const isHighlighted = idx === highlightIndex;

                return (
                  <li
                    key={opt.value}
                    onClick={() => handleSelect(opt.value)}
                    onMouseEnter={() => setHighlightIndex(idx)}
                    className={cn(
                      'px-3 py-1.5 text-xs flex items-center justify-between cursor-pointer transition-colors',
                      isHighlighted && 'bg-paper-hover text-brand-navy',
                      isSelected && 'font-semibold bg-brand-navy-light text-brand-navy'
                    )}
                  >
                    <div className="flex items-center gap-2 truncate">
                      <code className="font-mono text-[11px] font-bold text-brand-navy bg-paper-alt px-1 py-0.5 rounded border border-paper-border">
                        {opt.code}
                      </code>
                      <span className="truncate">{opt.label}</span>
                    </div>

                    <div className="flex items-center gap-2 flex-shrink-0 ml-2">
                      {opt.type && (
                        <Badge
                          variant={
                            opt.type.toLowerCase() as
                              | 'asset'
                              | 'liability'
                              | 'equity'
                              | 'income'
                              | 'expense'
                          }
                          className="text-[10px] px-1 py-0"
                        >
                          {opt.type}
                        </Badge>
                      )}
                      {isSelected && (
                        <Check className="w-3.5 h-3.5 text-ledger-green" />
                      )}
                    </div>
                  </li>
                );
              })
            )}
          </ul>
        </div>
      )}
    </div>
  );
};
