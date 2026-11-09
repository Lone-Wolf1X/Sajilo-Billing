import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';

interface Shortcut {
  key: string;
  code: string;
  label: string;
  path: string;
}

const SHORTCUTS: Shortcut[] = [
  { key: 'F2', code: 'F2', label: 'Period', path: '/periods' },
  { key: 'F4', code: 'F4', label: 'Contra', path: '/journal-entries/contra' },
  { key: 'F5', code: 'F5', label: 'Payment', path: '/payments/vendor' },
  { key: 'F6', code: 'F6', label: 'Receipt', path: '/payments/receipt' },
  { key: 'F7', code: 'F7', label: 'Journal Entry', path: '/journal-entries/new' },
  { key: 'F8', code: 'F8', label: 'Sales Invoice', path: '/invoices/new' },
  { key: 'F9', code: 'F9', label: 'Purchase Invoice', path: '/purchase-invoices/new' },
  { key: 'F10', code: 'F10', label: 'Stock Item', path: '/inventory/items' },
];

export const FunctionKeysBar: React.FC = () => {
  const navigate = useNavigate();

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Don't intercept if user is typing inside an input/textarea
      const target = e.target as HTMLElement;
      if (
        target &&
        (target.tagName === 'INPUT' ||
          target.tagName === 'TEXTAREA' ||
          target.isContentEditable)
      ) {
        return;
      }

      const shortcut = SHORTCUTS.find((s) => s.code === e.key);
      if (shortcut) {
        e.preventDefault();
        toast.info(`Shortcut [${shortcut.key}]: Opening ${shortcut.label}`);
        navigate(shortcut.path);
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [navigate]);

  return (
    <div className="bg-[#f5f2ea] border-b border-[#e0dcd0] py-1.5 px-4 md:px-6 flex items-center gap-2 overflow-x-auto shadow-inner text-xs">
      <span className="text-[11px] font-bold text-paper-muted uppercase tracking-wider mr-1 whitespace-nowrap">
        FAST KEYS:
      </span>

      <div className="flex items-center gap-2">
        {SHORTCUTS.map((shortcut) => (
          <button
            key={shortcut.key}
            onClick={() => navigate(shortcut.path)}
            className="key-tag hover:border-brand-navy cursor-pointer transition-colors"
            title={`Press ${shortcut.key} to open ${shortcut.label}`}
          >
            <kbd>{shortcut.key}</kbd>
            <span>{shortcut.label}</span>
          </button>
        ))}
      </div>

      <span className="ml-auto hidden xl:inline text-[11px] text-paper-muted italic whitespace-nowrap">
        💡 Press any function key (F2–F10) directly from keyboard
      </span>
    </div>
  );
};
