import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Stores shop and business identity details for bill headers and tax compliance.
class BusinessProfiles extends Table with SyncTableMixin {
  TextColumn get businessName => text().withLength(min: 1, max: 200)();
  TextColumn get businessNameNepali => text().nullable()();
  TextColumn get panVatNumber => text().withLength(min: 9, max: 9)();
  TextColumn get contactNumber => text().withLength(min: 10, max: 15)();
  TextColumn get shopAddress => text().nullable()();
  TextColumn get logoPath => text().nullable()();
  BoolColumn get isCurrent => boolean().withDefault(const Constant(true))();
}

