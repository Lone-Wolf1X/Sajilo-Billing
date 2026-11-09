import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Search, ChevronDown, PlusCircle } from 'lucide-react';

interface DropdownItem {
  label: string;
  badge?: string;
  to: string;
}

interface DropdownSection {
  header?: string;
  items: DropdownItem[];
  divider?: boolean;
}

interface NavMenu {
  id: string;
  title: string;
  sections?: DropdownSection[];
  to?: string;
}

const MENU_ITEMS: NavMenu[] = [
  {
    id: 'dashboard',
    title: 'Dashboard',
    to: '/dashboard',
  },
  {
    id: 'financial',
    title: 'Financial Core',
    sections: [
      {
        header: 'General Accounting',
        items: [
          { label: 'Chart of Accounts', badge: 'COA', to: '/accounts' },
          { label: 'Journal Entries (Vouchers)', badge: '[F7]', to: '/journal-entries' },
          { label: 'General Ledger Statement', to: '/ledger' },
        ],
      },
      {
        divider: true,
        header: 'Period & Closing',
        items: [
          { label: 'Accounting Periods', to: '/periods' },
          { label: 'Month-End Period Close', to: '/periods/close' },
        ],
      },
    ],
  },
  {
    id: 'billing',
    title: 'Billing & Invoices',
    sections: [
      {
        header: 'Sales (Receivables)',
        items: [
          { label: 'Sales Invoices', badge: '[F8]', to: '/invoices' },
          { label: 'Customer Payments', badge: '[F6]', to: '/payments/receipt' },
          { label: 'Credit Notes (Returns)', to: '/credit-notes' },
          { label: 'Customers & Aging', to: '/customers' },
        ],
      },
      {
        divider: true,
        header: 'Purchases (Payables)',
        items: [
          { label: 'Purchase Invoices (Bills)', badge: '[F9]', to: '/purchase-invoices' },
          { label: 'Vendor Payments', badge: '[F5]', to: '/payments/vendor' },
          { label: 'Vendors & AP Statement', to: '/vendors' },
        ],
      },
    ],
  },
  {
    id: 'inventory',
    title: 'Inventory',
    sections: [
      {
        header: 'Stock Operations',
        items: [
          { label: 'Stock Items & SKUs', badge: '[F10]', to: '/inventory/items' },
          { label: 'Warehouse Locations', to: '/inventory/warehouses' },
          { label: 'Stock Adjustments & Transfers', to: '/inventory/transfers' },
        ],
      },
      {
        divider: true,
        header: 'Valuation & Alerts',
        items: [
          { label: 'Stock Valuation Ledger (FIFO)', to: '/inventory/valuation' },
          { label: 'Reorder Level Alerts', to: '/inventory/alerts' },
        ],
      },
    ],
  },
  {
    id: 'banking',
    title: 'Banking & Treasury',
    sections: [
      {
        header: 'Bank Operations',
        items: [
          { label: 'Bank Account Register', to: '/banking/accounts' },
          { label: 'Bank Reconciliation (Auto Match)', to: '/banking/reconcile' },
          { label: 'Cheque Clearance Register', to: '/banking/cheques' },
        ],
      },
    ],
  },
  {
    id: 'reports',
    title: 'Financial Reports',
    sections: [
      {
        header: 'Primary Statements',
        items: [
          { label: 'Trial Balance', to: '/reports/trial-balance' },
          { label: 'Profit & Loss Statement (P&L)', to: '/reports/profit-loss' },
          { label: 'Balance Sheet', to: '/reports/balance-sheet' },
          { label: 'Cash Flow Statement', to: '/reports/cash-flow' },
        ],
      },
      {
        divider: true,
        header: 'Audit & Governance',
        items: [
          { label: 'Audit Trail & Change Logs', to: '/audit-trail' },
          { label: 'Double-Entry Integrity Check', to: '/reports/integrity' },
        ],
      },
    ],
  },
];

export const MainNav: React.FC = () => {
  const location = useLocation();
  const [openDropdown, setOpenDropdown] = useState<string | null>(null);

  return (
    <header className="bg-brand-navy border-b border-[#162c47] text-white sticky top-0 z-40 shadow-md">
      <div className="max-w-[1400px] mx-auto px-4 md:px-6 flex items-center justify-between h-14">
        {/* Left: Brand + Nav Menu */}
        <div className="flex items-center h-full gap-2 lg:gap-6">
          <Link
            to="/dashboard"
            className="flex items-center gap-2.5 font-serif font-bold text-xl tracking-wider text-white hover:opacity-95 transition-opacity mr-2"
          >
            <span className="w-7 h-7 bg-white text-brand-navy rounded flex items-center justify-center font-bold text-base font-serif shadow">
              S
            </span>
            <span>SAISA</span>
          </Link>

          {/* Menus */}
          <nav className="hidden md:flex items-center h-full gap-0.5">
            {MENU_ITEMS.map((menu) => {
              const isDirectLink = !menu.sections;
              const isActive = isDirectLink && location.pathname === menu.to;

              if (isDirectLink) {
                return (
                  <Link
                    key={menu.id}
                    to={menu.to!}
                    className={`px-3 py-1.5 text-sm font-medium rounded transition-colors whitespace-nowrap ${
                      isActive
                        ? 'bg-white/20 text-white shadow-inner'
                        : 'text-blue-100 hover:bg-white/10 hover:text-white'
                    }`}
                  >
                    {menu.title}
                  </Link>
                );
              }

              return (
                <div
                  key={menu.id}
                  className="relative h-full flex items-center"
                  onMouseEnter={() => setOpenDropdown(menu.id)}
                  onMouseLeave={() => setOpenDropdown(null)}
                >
                  <button
                    onClick={() =>
                      setOpenDropdown(openDropdown === menu.id ? null : menu.id)
                    }
                    className={`px-3 py-1.5 text-sm font-medium rounded flex items-center gap-1 transition-colors whitespace-nowrap ${
                      openDropdown === menu.id
                        ? 'bg-white/20 text-white'
                        : 'text-blue-100 hover:bg-white/10 hover:text-white'
                    }`}
                  >
                    <span>{menu.title}</span>
                    <ChevronDown className="w-3.5 h-3.5 opacity-70" />
                  </button>

                  {/* Dropdown Panel */}
                  {openDropdown === menu.id && (
                    <div className="absolute top-full left-0 bg-white border border-[#c9c2b3] shadow-xl rounded-md min-w-[240px] py-1.5 z-50 animate-in fade-in-50 duration-150">
                      {menu.sections?.map((section, sIdx) => (
                        <div key={sIdx}>
                          {section.divider && (
                            <div className="h-[1px] bg-paper-border my-1" />
                          )}
                          {section.header && (
                            <div className="px-4 py-1 text-[11px] font-bold uppercase tracking-wider text-paper-muted">
                              {section.header}
                            </div>
                          )}
                          {section.items.map((item, iIdx) => (
                            <Link
                              key={iIdx}
                              to={item.to}
                              onClick={() => setOpenDropdown(null)}
                              className="flex items-center justify-between px-4 py-1.5 text-sm text-paper-text hover:bg-paper-hover hover:text-brand-navy transition-colors"
                            >
                              <span>{item.label}</span>
                              {item.badge && (
                                <span className="text-[11px] font-mono text-paper-muted bg-paper-alt px-1.5 py-0.5 rounded border border-paper-border">
                                  {item.badge}
                                </span>
                              )}
                            </Link>
                          ))}
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </nav>
        </div>

        {/* Right: Quick Search & New Voucher Button */}
        <div className="flex items-center gap-3">
          <div className="relative hidden lg:block">
            <Search className="w-3.5 h-3.5 absolute left-2.5 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              placeholder="Search voucher, invoice, ledger..."
              className="pl-8 pr-3 py-1 text-xs bg-[#162c47] text-white placeholder-slate-400 rounded border border-[#2b4b73] focus:outline-none focus:border-white focus:bg-[#1a3354] w-56 transition-all"
            />
          </div>

          <Link
            to="/journal-entries/new"
            className="hidden sm:inline-flex items-center gap-1.5 text-xs font-medium bg-[#7a2e2e] hover:bg-[#923737] text-white px-3 py-1.5 rounded shadow-sm border border-[#5e2323] transition-colors"
          >
            <PlusCircle className="w-3.5 h-3.5" />
            <span>New Voucher [F7]</span>
          </Link>
        </div>
      </div>
    </header>
  );
};

