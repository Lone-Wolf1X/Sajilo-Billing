import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Search, ChevronDown, PlusCircle } from 'lucide-react';
import { useAuth } from '../../hooks/useAuth';

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
          { label: 'Payments & Receipts Register', to: '/payments' },
          { label: 'Customer Payments', badge: '[F6]', to: '/payments/receipt' },
          { label: 'Credit Notes (Returns)', to: '/credit-notes' },
          { label: 'AR Aging Analysis', to: '/reports/ar-aging' },
          { label: 'Customers Directory', to: '/customers' },
        ],
      },
      {
        divider: true,
        header: 'Purchases (Payables)',
        items: [
          { label: 'Purchase Invoices (Bills)', badge: '[F9]', to: '/purchase-invoices' },
          { label: 'Vendor Payments', badge: '[F5]', to: '/payments/vendor' },
          { label: 'Debit Notes (Returns)', to: '/debit-notes' },
          { label: 'AP Aging Analysis', to: '/reports/ap-aging' },
          { label: 'Vendors Directory', to: '/vendors' },
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
          { label: 'IRD भ्याट विवरण (Annex 13 • D-01/D-02)', badge: 'IRD', to: '/reports/ird-annex13' },
          { label: 'Trial Balance', to: '/reports/trial-balance' },
          { label: 'Profit & Loss Statement (P&L)', to: '/reports/profit-loss' },
          { label: 'Balance Sheet', to: '/reports/balance-sheet' },
          { label: 'Cash Flow Statement', to: '/reports/cash-flow' },
          { label: 'AR Debtors Aging', to: '/reports/ar-aging' },
          { label: 'AP Creditors Aging', to: '/reports/ap-aging' },
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
  {
    id: 'admin',
    title: 'Admin Panel',
    sections: [
      {
        header: 'Multi-Tenant & System Administration',
        items: [
          { label: 'ग्राहक तथा संस्था व्यवस्थापन (Tenants)', badge: 'Onboard', to: '/admin/tenants' },
          { label: 'इमेल कन्फिगरेसन (Email / SMTP)', badge: 'SMTP', to: '/admin/email-settings' },
        ],
      },
    ],
  },
  {
    id: 'settings',
    title: 'Company Setup',
    sections: [
      {
        header: 'Master Profile & Onboarding',
        items: [
          { label: 'Business Profile Wizard', badge: 'Setup', to: '/setup' },
          { label: 'Tax & Registered Office', to: '/settings/company-profile' },
        ],
      },
    ],
  },
];

export const MainNav: React.FC = () => {
  const location = useLocation();
  const { user } = useAuth();
  const [openDropdown, setOpenDropdown] = useState<string | null>(null);

  const roles = user?.roles || [];
  const isPlatformAdmin = roles.includes('PLATFORM_ADMIN') || user?.tenantCode === '_platform';
  const isCashierOnly = roles.includes('CASHIER') && !roles.includes('ADMIN') && !roles.includes('ACCOUNTANT');

  let activeMenus: NavMenu[] = [];

  if (isPlatformAdmin) {
    activeMenus = [
      { id: 'dashboard', title: 'Dashboard', to: '/dashboard' },
      { id: 'tenants', title: 'ग्राहक तथा लाइसेन्स (Tenants)', to: '/admin/tenants' },
      { id: 'email', title: 'इमेल कन्फिग (SMTP)', to: '/admin/email-settings' },
      { id: 'audit', title: 'अडिट लग (Audit Trail)', to: '/audit-trail' },
    ];
  } else if (isCashierOnly) {
    activeMenus = [
      { id: 'dashboard', title: 'Dashboard', to: '/dashboard' },
      {
        id: 'pos_billing',
        title: 'काउन्टर बिलिङ (POS)',
        sections: [
          {
            header: 'बिक्री अपरेशन',
            items: [
              { label: 'नयाँ बिक्री बिल बनाउनुहोस्', badge: '[F8]', to: '/invoices/new' },
              { label: 'बिक्री बिलहरूको सूची (Invoices)', to: '/invoices' },
              { label: 'ग्राहक भुक्तानी रसिद', badge: '[F6]', to: '/payments/receipt' },
              { label: 'ग्राहकहरूको सूची (Customers)', to: '/customers' },
            ],
          },
        ],
      },
      {
        id: 'pos_stock',
        title: 'सामान र मूल्य (Items)',
        sections: [
          {
            header: 'स्टक र मूल्य सूची',
            items: [
              { label: 'सामान तथा मौज्दात खोज्नुहोस्', badge: '[F10]', to: '/inventory/items' },
            ],
          },
        ],
      },
    ];
  } else {
    // Standard Owner / Accountant / Admin Menus
    activeMenus = MENU_ITEMS.filter((item) => {
      // Hide Platform Admin Panel from ordinary business owners
      if (item.id === 'admin') return false;
      return true;
    });
  }

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
            {activeMenus.map((menu) => {
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

