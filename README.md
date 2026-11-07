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

## Project Structure

```
Sajilo_Billing/
├── assets/
│   └── fonts/
│       ├── NotoSansDevanagari-Regular.ttf   <-- Embedded Nepali font
│       └── NotoSansDevanagari-Bold.ttf      <-- Embedded Nepali bold font
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── database/
│   │   │   ├── app_database.dart           <-- Drift database & connection
│   │   │   ├── app_database.g.dart         <-- Generated Drift schema
│   │   │   ├── database_provider.dart      <-- Riverpod provider for DB
│   │   │   ├── sync_status.dart            <-- SyncStatus enum (pending/synced/failed)
│   │   │   └── tables/
│   │   │       ├── sync_table_mixin.dart   <-- Common sync fields (id, syncStatus, remoteId)
│   │   │       ├── business_profiles_table.dart
│   │   │       ├── inventories_table.dart
│   │   │       ├── sales_table.dart
│   │   │       ├── sale_items_table.dart
│   │   │       ├── purchases_table.dart
│   │   │       └── bill_metadata_table.dart
│   │   ├── localization/
│   │   │   └── locale_provider.dart        <-- Language switcher (English / Nepali)
│   │   ├── theme/
│   │   │   └── app_theme.dart              <-- Desktop ergonomics & typography
│   │   └── utils/
│   │       └── nepali_validators.dart      <-- 9-digit PAN & 10-digit mobile validators
│   ├── features/
│   │   ├── onboarding/
│   │   │   └── presentation/
│   │   │       └── onboarding_screen.dart  <-- First-run shop setup wizard
│   │   ├── business/
│   │   │   ├── data/
│   │   │   │   └── business_repository.dart
│   │   │   └── presentation/
│   │   │       ├── business_provider.dart
│   │   │       └── edit_business_screen.dart
│   │   ├── inventory/
│   │   │   └── inventory_stub.dart         <-- Stub for Phase 2
│   │   ├── backup/
│   │   │   ├── domain/
│   │   │   │   └── backup_service.dart     <-- Abstract BackupService interface
│   │   │   ├── data/
│   │   │   │   └── local_backup_service.dart<-- SQLite file export & restore
│   │   │   └── presentation/
│   │   │       ├── backup_provider.dart
│   │   │       └── backup_screen.dart
│   │   ├── billing/
│   │   │   ├── domain/
│   │   │   │   └── bill_model.dart         <-- Bill items, calculation, & dummy factory
│   │   │   ├── data/
│   │   │   │   └── pdf_bill_generator.dart <-- Bilingual PDF & QR generator
│   │   │   └── presentation/
│   │   │       └── sample_bill_screen.dart <-- Interactive bill preview & exporter
│   │   └── settings/
│   │       └── presentation/
│   │           └── settings_screen.dart    <-- Profile overview, language & backup links
│   ├── shared/
│   │   └── widgets/
│   │       └── desktop_app_shell.dart      <-- Desktop NavigationRail sidebar
│   ├── l10n/
│   │   ├── app_en.arb                      <-- English translations
│   │   └── app_ne.arb                      <-- Nepali translations
│   └── main.dart                           <-- App entrypoint & routing
├── pubspec.yaml
└── l10n.yaml
```

---

## Font Asset Configuration (Devanagari)

For Devanagari text to render crisply both in the Flutter UI and inside generated PDF documents, TrueType font files are placed in:
```
assets/fonts/NotoSansDevanagari-Regular.ttf
assets/fonts/NotoSansDevanagari-Bold.ttf
```

These are registered in `pubspec.yaml` under `fonts` and `assets`:
```yaml
flutter:
  assets:
    - assets/fonts/

  fonts:
    - family: NotoSansDevanagari
      fonts:
        - asset: assets/fonts/NotoSansDevanagari-Regular.ttf
        - asset: assets/fonts/NotoSansDevanagari-Bold.ttf
          weight: 700
```
*Note: Both static TTF files are already bundled and verified in the repository.*

---

## How to Run on Desktop

### Prerequisites
1. **Flutter SDK** (>= 3.19.0) with desktop platform enabled:
   ```bash
   flutter config --enable-macos-desktop
   flutter config --enable-windows-desktop
   flutter config --enable-linux-desktop
   ```
2. Run dependency resolution & code generation:
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
Make sure "Desktop development with C++" workload is installed in Visual Studio.
```bash
flutter run -d windows
```

### Running on Linux
Ensure required libraries are installed (`clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`, `liblzma-dev`):
```bash
flutter run -d linux
```

---

## Phase 1 Feature Walkthrough

1. **First-Run Onboarding Wizard**:
   - Automatically displayed when no business profile exists in SQLite.
   - Enforces Nepali business validation:
     - 9-digit Nepali PAN/VAT number.
     - 10-digit Nepali mobile number (must start with 98, 97, or 96).
     - Business name and optional shop address.
     - Local logo file selector (persisted to application documents folder).
2. **Offline-First Archive Foundation**:
   - Every SQLite table (`business_profiles`, `inventories`, `sales`, `sale_items`, `purchases`, `bill_metadata`) contains:
     - `id` (UUID string)
     - `created_at` (DateTime)
     - `updated_at` (DateTime)
     - `sync_status` (`pending`, `synced`, `failed`)
     - `remote_id` (nullable string for future server sync)
3. **BackupService Interface & Local Implementation**:
   - Abstract `BackupService` defined with `backupNow()`, `restoreLatest()`, and `getLastBackupTime()`.
   - `LocalBackupService` exports the SQLite database file to user-specified directories using native desktop save dialogs.
   - Restores database files after verifying SQLite magic headers.
4. **Bilingual Tax Invoice (PDF & QR)**:
   - Formatted to Nepali retail billing standards ("TAX INVOICE / कर बिजक").
   - Bilingual labels:
     - Bill No / बिल नं.
     - Particulars / विवरण
     - Qty / परिमाण
     - Rate / दर
     - Subtotal / उप-जम्मा
     - Discount / छुट
     - 13% VAT / १३% भ्याट
     - Total / कुल जम्मा
   - Embedded QR code containing: invoice number, grand total, shop PAN, and digital verification hash.
   - Direct export via file dialog and native print support via `printing`.
5. **Real-Time Language Switcher**:
   - One-click toggle between English and Nepali in the navigation rail and settings screen.
