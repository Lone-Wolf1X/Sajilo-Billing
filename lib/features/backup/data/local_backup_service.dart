import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import '../domain/backup_service.dart';
import 'backup_repository.dart';

/// Desktop-first local SQLite database backup and restoration service.
/// Uses file_selector to let shopkeepers export and restore their database archives safely.
class LocalBackupService implements BackupService {
  final AppDatabase _db;
  final BackupRepository? _backupRepo;

  LocalBackupService(this._db, [this._backupRepo]);

  /// Resolves the metadata file that tracks backup timestamps.
  Future<File> _getMetaFile() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final metaDir = Directory(p.join(docsDir.path, 'SajiloBilling'));
    if (!await metaDir.exists()) {
      await metaDir.create(recursive: true);
    }
    return File(p.join(metaDir.path, 'backup_metadata.json'));
  }

  @override
  Future<DateTime?> getLastBackupTime() async {
    try {
      final metaFile = await _getMetaFile();
      if (!await metaFile.exists()) return null;
      final raw = await metaFile.readAsString();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final timeStr = map['last_backup_time'] as String?;
      return timeStr != null ? DateTime.parse(timeStr) : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _recordBackupTime(DateTime timestamp, String destination) async {
    try {
      final metaFile = await _getMetaFile();
      final data = {
        'last_backup_time': timestamp.toIso8601String(),
        'destination_path': destination,
      };
      await metaFile.writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  @override
  Future<String> backupNow({String? targetDirectoryPath}) async {
    final File dbFile = (await AppDatabase.getDatabaseFile()) as File;
    if (!await dbFile.exists()) {
      throw Exception('Database file does not exist yet at ${dbFile.path}');
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final suggestedFilename = 'sajilo_billing_backup_$timestamp.sqlite';

    String? destinationPath;

    if (targetDirectoryPath != null) {
      destinationPath = p.join(targetDirectoryPath, suggestedFilename);
    } else {
      // Prompt user with native desktop save dialog
      final FileSaveLocation? result = await getSaveLocation(
        suggestedName: suggestedFilename,
        acceptedTypeGroups: const [
          XTypeGroup(
            label: 'SQLite Database',
            extensions: ['sqlite', 'db'],
          )
        ],
      );

      if (result == null) {
        throw Exception('Backup cancelled by user');
      }
      destinationPath = result.path;
    }

    // Safely checkpoint / copy database file
    final destinationFile = File(destinationPath);
    if (!await destinationFile.parent.exists()) {
      await destinationFile.parent.create(recursive: true);
    }

    final repo = _backupRepo;
    String? logId;
    if (repo != null) {
      logId = await repo.logStart(location: 'local', fileName: p.basename(destinationPath));
    }

    try {
      await dbFile.copy(destinationPath);
      await _recordBackupTime(DateTime.now(), destinationPath);

      if (logId != null && repo != null) {
        final size = await File(destinationPath).length();
        await repo.logSuccess(id: logId, sizeBytes: size);
      }
    } catch (e) {
      if (logId != null && repo != null) {
        await repo.logFailure(id: logId, errorMessage: e.toString());
      }
      rethrow;
    }

    return destinationPath;
  }

  @override
  Future<bool> restoreLatest([String? sourcePath]) async {
    String? selectedPath = sourcePath;

    if (selectedPath == null) {
      const typeGroup = XTypeGroup(
        label: 'SQLite Database',
        extensions: ['sqlite', 'db'],
      );
      final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) {
        return false; // User cancelled
      }
      selectedPath = file.path;
    }

    final backupFile = File(selectedPath);
    if (!await backupFile.exists()) {
      throw Exception('Selected backup file does not exist: $selectedPath');
    }

    // Verify it is a valid SQLite file by checking the magic header
    final headerBytes = await backupFile.openRead(0, 16).first;
    final headerString = utf8.decode(headerBytes.take(15).toList(), allowMalformed: true);
    if (!headerString.startsWith('SQLite format 3')) {
      throw Exception('Invalid backup file: not a recognized SQLite database.');
    }

    // Target database file
    final File currentDbFile = (await AppDatabase.getDatabaseFile()) as File;

    // Close active database connections first
    await _db.close();

    // Replace current database with backup
    await backupFile.copy(currentDbFile.path);

    // Also remove any stale WAL / SHM files if present
    final walFile = File('${currentDbFile.path}-wal');
    final shmFile = File('${currentDbFile.path}-shm');
    if (await walFile.exists()) await walFile.delete();
    if (await shmFile.exists()) await shmFile.delete();

    return true;
  }
}

