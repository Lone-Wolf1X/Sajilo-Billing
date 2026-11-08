import 'package:drift/drift.dart';

/// Atomic sequential counter for generating unique, gapless invoice numbers (e.g. SB-2082-0001).
class BillSequence extends Table {
  TextColumn get sequenceType => text()(); // e.g. 'SALES_INVOICE'
  TextColumn get fiscalYear => text()(); // e.g. '2081/82' or '2082'
  TextColumn get prefix => text().withDefault(const Constant('SB'))();
  IntColumn get currentNumber => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {sequenceType, fiscalYear};
}

