import { createBrowserRouter, Navigate } from 'react-router-dom';
import { LoginPage } from './pages/LoginPage';
import { RegisterPage } from './pages/RegisterPage';
import { DashboardPage } from './pages/DashboardPage';
import { ChartOfAccountsPage } from './pages/accounts/ChartOfAccountsPage';
import { JournalEntriesPage } from './pages/journal/JournalEntriesPage';
import { JournalEntryFormPage } from './pages/journal/JournalEntryFormPage';
import { JournalEntryDetailPage } from './pages/journal/JournalEntryDetailPage';
import { GeneralLedgerPage } from './pages/ledger/GeneralLedgerPage';
import { SalesInvoicesPage } from './pages/invoices/SalesInvoicesPage';
import { SalesInvoiceFormPage } from './pages/invoices/SalesInvoiceFormPage';
import { SalesInvoiceDetailPage } from './pages/invoices/SalesInvoiceDetailPage';
import { PurchaseInvoicesPage } from './pages/invoices/PurchaseInvoicesPage';
import { PurchaseInvoiceFormPage } from './pages/invoices/PurchaseInvoiceFormPage';
import { PaymentFormPage } from './pages/payments/PaymentFormPage';
import { PaymentsPage } from './pages/payments/PaymentsPage';
import { PaymentDetailPage } from './pages/payments/PaymentDetailPage';
import { BankAccountsPage } from './pages/bankAccounts/BankAccountsPage';
import { ArAgingPage } from './pages/aging/ArAgingPage';
import { ApAgingPage } from './pages/aging/ApAgingPage';
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
            element: <JournalEntriesPage />,
          },
          {
            path: 'journal-entries/new',
            element: <JournalEntryFormPage />,
          },
          {
            path: 'journal-entries/:id',
            element: <JournalEntryDetailPage />,
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
            element: <GeneralLedgerPage />,
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
            element: <SalesInvoicesPage />,
          },
          {
            path: 'invoices/new',
            element: <SalesInvoiceFormPage />,
          },
          {
            path: 'invoices/:id',
            element: <SalesInvoiceDetailPage />,
          },
          {
            path: 'payments',
            element: <PaymentsPage />,
          },
          {
            path: 'payments/receipt',
            element: <PaymentFormPage mode="receipt" />,
          },
          {
            path: 'payments/new-receipt',
            element: <PaymentFormPage mode="receipt" />,
          },
          {
            path: 'payments/vendor',
            element: <PaymentFormPage mode="payment" />,
          },
          {
            path: 'payments/new-payment',
            element: <PaymentFormPage mode="payment" />,
          },
          {
            path: 'payments/:id',
            element: <PaymentDetailPage />,
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
            element: <PurchaseInvoicesPage />,
          },
          {
            path: 'purchase-invoices/new',
            element: <PurchaseInvoiceFormPage />,
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
            element: <BankAccountsPage />,
          },
          {
            path: 'bank-accounts',
            element: <BankAccountsPage />,
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
            path: 'reports/ar-aging',
            element: <ArAgingPage />,
          },
          {
            path: 'reports/ap-aging',
            element: <ApAgingPage />,
          },
          {
            path: 'customers/aging',
            element: <ArAgingPage />,
          },
          {
            path: 'vendors/aging',
            element: <ApAgingPage />,
          },
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
