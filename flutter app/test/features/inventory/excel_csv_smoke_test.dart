import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CSV encoding and decoding works', () {
    final rows = [
      ['Name', 'Price'],
      ['Watch', '2500'],
    ];
    final csvStr = const ListToCsvConverter().convert(rows);
    final decoded = const CsvToListConverter().convert(csvStr);
    expect(decoded.length, equals(2));
    expect(decoded[1][0], equals('Watch'));
  });

  test('Excel encoding and decoding works', () {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    sheet.appendRow([TextCellValue('Name'), TextCellValue('Price')]);
    sheet.appendRow([TextCellValue('Casio Watch'), TextCellValue('2500')]);
    final bytes = excel.save();
    expect(bytes, isNotNull);

    final readExcel = Excel.decodeBytes(bytes!);
    final readSheet = readExcel.tables['Sheet1']!;
    expect(readSheet.rows.length, equals(2));
  });
}
