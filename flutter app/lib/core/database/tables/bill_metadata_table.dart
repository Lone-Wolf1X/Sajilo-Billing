import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Metadata for generated bill PDFs, QR verification strings, and audit logs.
class BillMetadata extends Table with SyncTableMixin {
  TextColumn get saleId => text()();
  TextColumn get billNumber => text()();
  TextColumn get pdfFilePath => text()();
  TextColumn get qrData => text()();
  IntColumn get printCount => integer().withDefault(const Constant(1))();
}

