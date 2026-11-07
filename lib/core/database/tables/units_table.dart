import 'package:drift/drift.dart';
import 'sync_table_mixin.dart';

/// Configurable measurement units (e.g. pcs, kg, ltr, pkt, box, bag).
class Units extends Table with SyncTableMixin {
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get symbol => text().withLength(min: 1, max: 20)();
  TextColumn get nepaliSymbol => text().nullable()();
  BoolColumn get isFractional => boolean().withDefault(const Constant(false))();
}
