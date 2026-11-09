import { createBrowserRouter, Navigate } from 'react-router-dom';
import { LoginPage } from './pages/LoginPage';
import { RegisterPage } from './pages/RegisterPage';
import { DashboardPage } from './pages/DashboardPage';
import { ChartOfAccountsPage } from './pages/accounts/ChartOfAccountsPage';
import { JournalEntryFormPage } from './pages/journal/JournalEntryFormPage';
import { ModulePlaceholderPage } from './pages/ModulePlaceholderPage';
import { ProtectedRoute } from './components/auth/ProtectedRoute';
import { AppLayout } from './components/layout/AppLayout';

export const router = createBrowserRouter([
  {
    path: '/login',
    element: <LoginPage />,
  },
  {
    path: '/register',
    element: <RegisterPage />,
  },
  {
    element: <ProtectedRoute />,
    children: [
      {
        path: '/',
        element: <AppLayout />,
        children: [
          {
            index: true,
            element: <Navigate to="/dashboard" replace />,
          },
          {
            path: 'dashboard',
            element: <DashboardPage />,
          },
          // Financial Core
          {
            path: 'accounts',
            element: <ChartOfAccountsPage />,
          },
          {
            path: 'journal-entries',
            element: (
              <ModulePlaceholderPage
                title="Journal Entries & Vouchers"
                stepName="Step 16 Part 3B"
              />
            ),
          },
          {
            path: 'journal-entries/new',
            element: <JournalEntryFormPage />,
          },
          {
            path: 'journal-entries/:id',
            element: (
              <ModulePlaceholderPage
                title="Journal Entry Details"
                stepName="Step 16 Part 3B"
              />
            ),
          },
          {
            path: 'journal-entries/contra',
            element: (
              <ModulePlaceholderPage
                title="Contra Voucher Entry [F4]"
                stepName="Step 16: Financial Core UI"
              />
            ),
          },
          {
            path: 'ledger',
            element: (
              <ModulePlaceholderPage
                title="General Ledger Statement"
                stepName="Step 16: Financial Core UI"
              />
            ),
          },
          {
            path: 'periods',
            element: (
              <ModulePlaceholderPage
                title="Accounting Periods [F2]"
                stepName="Step 16: Financial Core UI"
              />
            ),
          },
          {
            path: 'periods/close',
            element: (
              <ModulePlaceholderPage
                title="Month-End Period Close"
                stepName="Step 16: Financial Core UI"
              />
            ),
          },
          // Billing & Invoices
          {
            path: 'invoices',
            element: (
              <ModulePlaceholderPage
                title="Sales Invoices"
                stepName="Step 17: Billing & Invoicing UI"
              />
            ),
          },
          {
            path: 'invoices/new',
            element: (
              <ModulePlaceholderPage
                title="New Sales Invoice [F8]"
                stepName="Step 17: Billing & Invoicing UI"
              />
            ),
          },
          {
            path: 'payments/receipt',
            element: (
              <ModulePlaceholderPage
                title="Customer Payment Receipt [F6]"
                stepName="Step 17: Billing & Invoicing UI"
              />
            ),
          },
          {
            path: 'credit-notes',
            element: (
              <ModulePlaceholderPage
                title="Credit Notes & Sales Returns"
                stepName="Step 19: Credit Notes UI"
              />
            ),
          },
          {
            path: 'customers',
            element: (
              <ModulePlaceholderPage
                title="Customer Directory & Receivables Aging"
                stepName="Step 17: Billing & Invoicing UI"
              />
            ),
          },
          // Purchases & Inventory
          {
            path: 'purchase-invoices',
            element: (
              <ModulePlaceholderPage
                title="Purchase Invoices (Bills) [F9]"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          {
            path: 'purchase-invoices/new',
            element: (
              <ModulePlaceholderPage
                title="New Purchase Invoice [F9]"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          {
            path: 'payments/vendor',
            element: (
              <ModulePlaceholderPage
                title="Vendor Payment Voucher [F5]"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          {
            path: 'vendors',
            element: (
              <ModulePlaceholderPage
                title="Vendor Directory & Accounts Payable"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          {
            path: 'inventory/items',
            element: (
              <ModulePlaceholderPage
                title="Stock Items & SKU Catalog [F10]"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          {
            path: 'inventory/warehouses',
            element: (
              <ModulePlaceholderPage
                title="Warehouse Locations"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          {
            path: 'inventory/transfers',
            element: (
              <ModulePlaceholderPage
                title="Stock Adjustments & Transfers"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          {
            path: 'inventory/valuation',
            element: (
              <ModulePlaceholderPage
                title="Stock Valuation Ledger (FIFO)"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          {
            path: 'inventory/alerts',
            element: (
              <ModulePlaceholderPage
                title="Stock Reorder Threshold Alerts"
                stepName="Step 18: Inventory & Purchasing UI"
              />
            ),
          },
          // Banking
          {
            path: 'banking/accounts',
            element: (
              <ModulePlaceholderPage
                title="Bank Account Register"
                stepName="Step 20: Bank Reconciliation UI"
              />
            ),
          },
          {
            path: 'banking/reconcile',
            element: (
              <ModulePlaceholderPage
                title="Bank Reconciliation Statement"
                stepName="Step 20: Bank Reconciliation UI"
              />
            ),
          },
          {
            path: 'banking/cheques',
            element: (
              <ModulePlaceholderPage
                title="Cheque Clearance Register"
                stepName="Step 20: Bank Reconciliation UI"
              />
            ),
          },
          // Reports
          {
            path: 'reports/trial-balance',
            element: (
              <ModulePlaceholderPage
                title="Trial Balance Report"
                stepName="Step 21: Financial Reports UI"
              />
            ),
          },
          {
            path: 'reports/profit-loss',
            element: (
              <ModulePlaceholderPage
                title="Profit & Loss Statement (P&L)"
                stepName="Step 21: Financial Reports UI"
              />
            ),
          },
          {
            path: 'reports/balance-sheet',
            element: (
              <ModulePlaceholderPage
                title="Balance Sheet Report"
                stepName="Step 21: Financial Reports UI"
              />
            ),
          },
          {
            path: 'reports/cash-flow',
            element: (
              <ModulePlaceholderPage
                title="Cash Flow Statement"
                stepName="Step 21: Financial Reports UI"
              />
            ),
          },
          {
            path: 'reports/integrity',
            element: (
              <ModulePlaceholderPage
                title="Double-Entry Integrity Check"
                stepName="Step 21: Financial Reports UI"
              />
            ),
          },
          {
            path: 'audit-trail',
            element: (
              <ModulePlaceholderPage
                title="System Audit Trail & Security Logs"
                stepName="Step 21: Financial Reports UI"
              />
            ),
          },
          {
            path: '*',
            element: <ModulePlaceholderPage title="Page Not Found" />,
          },
        ],
      },
    ],
  },
  {
    path: '*',
    element: <Navigate to="/login" replace />,
  },
]);
