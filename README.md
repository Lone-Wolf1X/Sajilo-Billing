# Sajilo Billing (सजिलो बिलिङ)

**Sajilo Billing** is an offline-first, desktop-first billing and retail accounting system designed specifically for Nepali shopkeepers (retailers, pan/kirana stores, wholesalers). Built with Flutter & Dart, the system operates completely offline, storing records in local SQLite using Drift and generating bilingual Tax Invoices (English + Nepali Devanagari) with embedded verification QR codes.

---

## Architecture & Tech Stack

- **Framework**: Flutter (Desktop-first targeting Windows, macOS, Linux, with zero OS hardcoding to enable seamless Mobile & Web expansions).
- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) 2.x.
- **Local Database**: [drift](https://pub.dev/packages/drift) with [sqlite3_flutter_libs](https://pub.dev/packages/sqlite3_flutter_libs) for high-performance offline SQLite (WAL mode, foreign keys, sync-ready schema).
- **Localization**: Official `flutter_localizations` + ARB files (`ne` for Nepali, `en` for English).
- **PDF Engine**: [pdf](https://pub.dev/packages/pdf) and [printing](https://pub.dev/packages/printing) with embedded `NotoSansDevanagari` TrueType font.
- **QR Code**: [qr_flutter](https://pub.dev/packages/qr_flutter) for on-screen inspection and PDF `pw.BarcodeWidget` for fiscal verification.
- **Path Resolution**: [path_provider](https://pub.dev/packages/path_provider) exclusively for all database, logo, and generated invoice file paths.
- **File Dialogs**: [file_selector](https://pub.dev/packages/file_selector) for desktop native file picking and folder exports.

---

## Core Engineering & Consistency Architecture (Step 2)

### 1. Stock Ledger vs. `stock_qty` Cache Consistency
- **Auditability via `stock_ledger`**: The `stock_ledger` table is the immutable, single source of truth for all inventory movements.
- **Cache for High-Throughput POS**: Reading the entire ledger history to compute stock at checkout would degrade performance as history grows. Therefore, the `items` table maintains a cached `stock_qty` column.
- **Atomic Multi-Table Transactions**: Every operation affecting inventory (Supplier Purchase intake, Sales checkout, Void invoices, Purchase returns, or Audited Stock Adjustments) executes within a single `_db.transaction(() async { ... })`:
  1. Validates quantity preconditions (e.g. preventing checkout if stock is insufficient).
  2. Appends an immutable row to `stock_ledger` (`item_id`, `qty_change`, `reason`, `ref_type`, `ref_id`, `notes`).
  3. Increments or decrements `items.stock_qty`.
  4. Both writes commit together or roll back completely if any step fails.
- **Stock Immutability**: Users cannot arbitrarily edit stock quantity. Changes must go through the audited Stock Adjustment screen, which logs physical count corrections with mandatory reasons in `stock_adjustments`.

### 2. Gapless, Unique Bill Numbering (`bill_sequence`)
- Invoices follow standard Nepali fiscal formats (e.g., `SB-2082-0001`).
- An atomic sequence table (`bill_sequence`) tracks the last generated sequence number per fiscal year (`sequence_type`, `fiscal_year`, `prefix`, `current_number`).
- Inside the checkout transaction, the next sequence number is reserved and committed together with the `sales` record, guaranteeing freedom from gaps and duplicate bill numbers even under rapid counter billing.

### 3. Financial Precision with Integer Paisa
- All prices, rates, subtotals, discounts, VAT amounts, and grand totals are stored as integers in **paisa** (1 Rupee = 100 Paisa).
- Managed via `PaisaHelper`, eliminating floating-point IEEE-754 precision issues (e.g., `0.1 + 0.2 != 0.3`).
- Display outputs format with proper South Asian thousands separators (`Rs. 2,550.00` / `रु. 2,550.00`) and convert to English/Nepali words for tax invoices.

### 4. Sync-Readiness Hooks for Cloud Backup
- Every table incorporates `SyncTableMixin`:
  - `id` (UUID v4 string)
  - `created_at` (UTC timestamp)
  - `updated_at` (UTC timestamp)
  - `sync_status` (`SyncStatus` enum: `pending`, `synced`, `failed`)
  - `remote_id` (nullable string for future server primary keys)
  - `is_deleted` (boolean soft-delete flag)
- **Soft Deletes**: Business records are never hard-deleted from SQLite. When an item is deleted or an invoice is voided, `is_deleted = true`, `updated_at = now`, and `sync_status = pending` are set, ensuring tombstones propagate during synchronization.
- **Future Sync Engine**: When cloud synchronization is connected in future phases, the sync worker simply queries records with `sync_status == pending` across all tables, batches them to the API, and sets `sync_status = synced` upon acknowledgement.

---

## Google Sign-In & Google Drive Backup Architecture (Step 3)

### 1. 100% Offline-Safe & Strictly Opt-In
- If no internet is present or no Google account is connected, Sajilo Billing functions 100% offline as a local retail system.
- No network requests touch Google until the shopkeeper explicitly clicks **"Connect Google Drive"** in Settings.
- The app prominently displays an **"Offline Mode is active"** status banner when disconnected or offline.

### 2. Desktop PKCE OAuth 2.0 Loopback Flow
- Designed specifically for Flutter Desktop (Windows, macOS, Linux).
- Uses standard installed-app loopback URI (`http://127.0.0.1:<random_port>`).
- Enforces cryptographic **PKCE (S256)** with a cryptographically secure `code_verifier` (RFC 7636) and SHA-256 `code_challenge`.
- Minimal scope: strictly requests `https://www.googleapis.com/auth/drive.file` (per-app files created by Sajilo Billing only). Never requests or accesses full Drive files.
- `refresh_token` is stored exclusively in OS keychain / encrypted storage via `flutter_secure_storage`. It is never stored in SQLite, log files, or plaintext settings.

### 3. Backup Package & Retention
- **Archive Format**: Compressed ZIP archive containing `database.sqlite` (checkpointed SQLite database) and `settings.json` (metadata: schema version, app version, timestamp, business profile).
- **Dedicated Folder**: Automatically resolves or creates a dedicated `Sajilo Billing Backups` folder in the shopkeeper's Google Drive.
- **14-Day Retention**: Retains the last 14 backups, automatically pruning older archives to conserve user storage quota.
- **Safe Restoration**:
  1. Validates schema version compatibility against current app version.
  2. Generates an immediate pre-restore local safety copy: `restored-overwrite-<timestamp>.sqlite`.
  3. Displays a confirmation dialog with backup details, shop info, and mandatory checkbox before overwriting.

### 4. Audit Logging & Schema Migration (v2 -> v3)
- Schema upgraded to v3 with a new `backup_logs` table (extends `SyncTableMixin`).
- Tracks all operations: `started_at`, `finished_at`, `status` (`success`, `failed`, `in_progress`), `location` (`local`, `drive`), `file_name`, `size_bytes`, `error_message`, and `google_account_email`.
- Displayed in real-time in the **Backup History & Audit Log** list.

---

## Project Structure

```
Sajilo_Billing/
├── assets/
│   └── fonts/
│       ├── NotoSansDevanagari-Regular.ttf   <-- Embedded Nepali font
│       └── NotoSansDevanagari-Bold.ttf      <-- Embedded Nepali bold font
├── lib/
│   ├── core/
│   │   ├── database/
│   │   │   ├── app_database.dart           <-- Drift database & migrations (v1 -> v2)
│   │   │   ├── app_database.g.dart         <-- Generated Drift schema
│   │   │   ├── database_provider.dart      <-- Riverpod provider for DB
│   │   │   ├── sync_status.dart            <-- SyncStatus enum
│   │   │   └── tables/
│   │   │       ├── sync_table_mixin.dart   <-- id, timestamps, sync_status, remote_id, is_deleted
│   │   │       ├── business_profiles_table.dart
│   │   │       ├── categories_table.dart   <-- Product categories
│   │   │       ├── units_table.dart        <-- Configurable measurement units
│   │   │       ├── items_table.dart        <-- Items master with paisa pricing & stock cache
│   │   │       ├── suppliers_table.dart    <-- Wholesale suppliers
│   │   │       ├── customers_table.dart    <-- Retail & credit customers
│   │   │       ├── stock_ledger_table.dart <-- Audit stock movements
│   │   │       ├── stock_adjustments_table.dart <-- Audited count corrections
│   │   │       ├── purchases_table.dart    <-- Supplier purchase intake
│   │   │       ├── purchase_items_table.dart
│   │   │       ├── sales_table.dart        <-- Retail sales & invoices
│   │   │       ├── sale_items_table.dart
│   │   │       ├── bill_sequence_table.dart<-- Atomic bill numbering
│   │   │       └── bill_metadata_table.dart
│   │   ├── localization/
│   │   │   └── locale_provider.dart        <-- English / Nepali switcher
│   │   ├── theme/
│   │   │   └── app_theme.dart              <-- Desktop ergonomics & typography
│   │   └── utils/
│   │       ├── nepali_validators.dart      <-- 9-digit PAN & 10-digit mobile validators
│   │       └── paisa_helper.dart           <-- Safe integer paisa conversions & number-to-words
│   ├── features/
│   │   ├── dashboard/                      <-- Basic store dashboard with real-time metrics
│   │   ├── inventory/                      <-- Item master, search, category filter, stock adjustments
│   │   ├── purchase/                       <-- Supplier purchases, multi-line intake, stock increase
│   │   ├── billing/                        <-- POS counter billing, stock deduction, sales register, PDF & QR
│   │   ├── onboarding/                     <-- First-run shop setup wizard
│   │   ├── business/                       <-- Edit business profile
│   │   └── backup/                         <-- LocalBackupService & export/restore dialogs
│   ├── shared/
│   │   └── widgets/
│   │       └── desktop_app_shell.dart      <-- Persistent NavigationRail
│   ├── l10n/
│   │   ├── app_en.arb                      <-- English translations
│   │   └── app_ne.arb                      <-- Nepali translations
│   └── main.dart                           <-- App entrypoint
├── test/
│   ├── business_logic_test.dart            <-- Paisa arithmetic & line calculation tests
│   └── widget_test.dart                    <-- Validator tests
├── pubspec.yaml
└── README.md
```

---

## How to Run on Desktop

### Prerequisites
1. **Flutter SDK** (>= 3.19.0) with desktop platform enabled:
   ```bash
   flutter config --enable-macos-desktop
   flutter config --enable-windows-desktop
   flutter config --enable-linux-desktop
   ```
2. Generate code and localizations:
   ```bash
   flutter pub get
   flutter gen-l10n
   dart run build_runner build --delete-conflicting-outputs
   ```

### Running on macOS
```bash
flutter run -d macos
```

### Running on Windows
```bash
flutter run -d windows
```

### Running on Linux
```bash
flutter run -d linux
```
