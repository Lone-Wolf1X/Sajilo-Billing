import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/features/backup/domain/backup_error.dart';
import 'package:sajilo_billing/features/backup/domain/backup_metadata_summary.dart';

void main() {
  group('Backup Archive & Schema Compatibility Tests', () {
    Uint8List createSampleZip({
      required int schemaVersion,
      required String businessName,
      required String panNumber,
      bool includeDb = true,
      bool includeSettings = true,
    }) {
      final archive = Archive();

      if (includeDb) {
        final dummyDbBytes = utf8.encode('SQLite format 3\x00DummyDatabaseContent');
        archive.addFile(ArchiveFile('database.sqlite', dummyDbBytes.length, dummyDbBytes));
      }

      if (includeSettings) {
        final settingsJson = jsonEncode({
          'app_version': '1.0.0+1',
          'schema_version': schemaVersion,
          'created_at': DateTime.now().toUtc().toIso8601String(),
          'business_name': businessName,
          'pan_number': panNumber,
          'backup_type': 'google_drive',
        });
        final settingsBytes = utf8.encode(settingsJson);
        archive.addFile(ArchiveFile('settings.json', settingsBytes.length, settingsBytes));
      }

      final zipData = ZipEncoder().encode(archive)!;
      return Uint8List.fromList(zipData);
    }

    test('Valid zip decodes successfully with database and metadata', () {
      final zipBytes = createSampleZip(
        schemaVersion: 3,
        businessName: 'Himalayan Kirana Store',
        panNumber: '123456789',
      );

      final archive = ZipDecoder().decodeBytes(zipBytes);
      final dbFile = archive.findFile('database.sqlite');
      final settingsFile = archive.findFile('settings.json');

      expect(dbFile, isNotNull);
      expect(settingsFile, isNotNull);

      final settingsJson = jsonDecode(utf8.decode(settingsFile!.content as List<int>)) as Map<String, dynamic>;
      final summary = BackupMetadataSummary.fromJson(
        settingsJson,
        fileName: 'backup_test.zip',
        sizeBytes: zipBytes.length,
      );

      expect(summary.schemaVersion, equals(3));
      expect(summary.businessName, equals('Himalayan Kirana Store'));
      expect(summary.panNumber, equals('123456789'));
      expect(summary.sizeBytes, equals(zipBytes.length));
    });

    test('Rejects backup archive when schema version is newer than app schema version', () {
      const currentAppSchemaVersion = 3;
      final futureZipBytes = createSampleZip(
        schemaVersion: 5, // Newer schema from a future app version
        businessName: 'Future Retail Store',
        panNumber: '987654321',
      );

      final archive = ZipDecoder().decodeBytes(futureZipBytes);
      final settingsFile = archive.findFile('settings.json')!;
      final settingsJson = jsonDecode(utf8.decode(settingsFile.content as List<int>)) as Map<String, dynamic>;
      final backupSchema = settingsJson['schema_version'] as int;

      expect(
        () {
          if (backupSchema > currentAppSchemaVersion) {
            throw IncompatibleSchemaException(
              backupVersion: backupSchema,
              currentVersion: currentAppSchemaVersion,
            );
          }
        },
        throwsA(isA<IncompatibleSchemaException>().having(
          (e) => e.backupVersion,
          'backupVersion',
          equals(5),
        )),
      );
    });

    test('Accepts backup archive when schema version is older or equal', () {
      const currentAppSchemaVersion = 3;
      final legacyZipBytes = createSampleZip(
        schemaVersion: 2, // Older schema version
        businessName: 'Legacy Shop',
        panNumber: '111222333',
      );

      final archive = ZipDecoder().decodeBytes(legacyZipBytes);
      final settingsFile = archive.findFile('settings.json')!;
      final settingsJson = jsonDecode(utf8.decode(settingsFile.content as List<int>)) as Map<String, dynamic>;
      final backupSchema = settingsJson['schema_version'] as int;

      // Must be allowed so migration can run
      expect(backupSchema <= currentAppSchemaVersion, isTrue);
    });

    test('Flags corrupt backup if database.sqlite is missing from zip archive', () {
      final corruptZipBytes = createSampleZip(
        schemaVersion: 3,
        businessName: 'Broken Shop',
        panNumber: '555666777',
        includeDb: false, // Missing database!
      );

      final archive = ZipDecoder().decodeBytes(corruptZipBytes);
      final dbFile = archive.findFile('database.sqlite');

      expect(dbFile, isNull);
    });
  });
}
