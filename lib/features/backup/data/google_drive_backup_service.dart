import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../../core/database/app_database.dart';
import '../domain/backup_error.dart';
import '../domain/backup_metadata_summary.dart';
import '../domain/backup_progress.dart';
import '../domain/backup_service.dart';
import 'backup_repository.dart';
import 'google_auth_service.dart';

/// Concrete implementation of [BackupService] that archives SQLite database
/// and metadata to Google Drive using minimal `drive.file` scope.
class GoogleDriveBackupService implements BackupService {
  static const String backupFolderName = 'Sajilo Billing Backups';
  static const int maxRetentionCount = 14;

  final AppDatabase _db;
  final GoogleAuthService _authService;
  final BackupRepository _backupRepo;
  final http.Client _httpClient;

  final StreamController<BackupProgress> _progressController =
      StreamController<BackupProgress>.broadcast();

  String? _cachedFolderId;

  GoogleDriveBackupService({
    required AppDatabase db,
    required GoogleAuthService authService,
    required BackupRepository backupRepo,
    http.Client? httpClient,
  })  : _db = db,
        _authService = authService,
        _backupRepo = backupRepo,
        _httpClient = httpClient ?? http.Client();

  /// Stream of real-time progress updates during backup or restore.
  Stream<BackupProgress> get progressStream => _progressController.stream;

  void _emitProgress(BackupStep step, double percentage, String message) {
    if (!_progressController.isClosed) {
      _progressController.add(BackupProgress(
        step: step,
        percentage: percentage,
        message: message,
      ));
    }
  }

  @override
  Future<DateTime?> getLastBackupTime() async {
    return await _backupRepo.getLastSuccessfulBackupTime(location: 'drive');
  }

  /// Locates or creates the dedicated 'Sajilo Billing Backups' folder in Drive.
  Future<String> _getOrCreateBackupFolder(String accessToken) async {
    if (_cachedFolderId != null) return _cachedFolderId!;

    final searchUri = Uri.https('www.googleapis.com', '/drive/v3/files', {
      'q': "name = '$backupFolderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
      'spaces': 'drive',
      'fields': 'files(id, name)',
    });

    final searchResponse = await _httpClient.get(
      searchUri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (searchResponse.statusCode == 401) {
      throw const AuthRevokedException();
    }

    if (searchResponse.statusCode == 200) {
      final data = jsonDecode(searchResponse.body) as Map<String, dynamic>;
      final files = data['files'] as List<dynamic>? ?? [];
      if (files.isNotEmpty) {
        _cachedFolderId = files.first['id'] as String;
        return _cachedFolderId!;
      }
    }

    // Folder doesn't exist, create it
    final createUri = Uri.https('www.googleapis.com', '/drive/v3/files');
    final createResponse = await _httpClient.post(
      createUri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': backupFolderName,
        'mimeType': 'application/vnd.google-apps.folder',
      }),
    );

    if (createResponse.statusCode == 200 || createResponse.statusCode == 201) {
      final folderData = jsonDecode(createResponse.body) as Map<String, dynamic>;
      _cachedFolderId = folderData['id'] as String;
      return _cachedFolderId!;
    } else {
      throw DriveFolderNotFoundException(
        'Failed to create backup folder: ${createResponse.statusCode} - ${createResponse.body}',
      );
    }
  }

  /// Creates a compressed ZIP containing active SQLite database and settings.json metadata.
  Future<Uint8List> _createBackupZip() async {
    final File dbFile = (await AppDatabase.getDatabaseFile()) as File;
    if (!await dbFile.exists()) {
      throw const CorruptBackupException('Database file does not exist locally.');
    }

    final dbBytes = await dbFile.readAsBytes();

    // Fetch business profile to embed in metadata
    final profile = await (_db.select(_db.businessProfiles)..limit(1)).getSingleOrNull();

    final settingsMap = {
      'app_version': '1.0.0+1',
      'schema_version': _db.schemaVersion,
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'business_name': profile?.businessName ?? '',
      'pan_number': profile?.panVatNumber ?? '',
      'contact': profile?.contactNumber ?? '',
      'backup_type': 'google_drive',
    };

    final settingsBytes = utf8.encode(jsonEncode(settingsMap));

    final archive = Archive();
    archive.addFile(ArchiveFile('database.sqlite', dbBytes.length, dbBytes));
    archive.addFile(ArchiveFile('settings.json', settingsBytes.length, settingsBytes));

    final encoder = ZipEncoder();
    final zipData = encoder.encode(archive);
    if (zipData == null) {
      throw const CorruptBackupException('Failed to compress backup files.');
    }

    return Uint8List.fromList(zipData);
  }

  @override
  Future<String> backupNow({String? targetDirectoryPath}) async {
    _emitProgress(BackupStep.preparing, 0.05, 'Verifying account and connection...');

    final email = await _authService.getConnectedEmail();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'sajilo_billing_backup_$timestamp.zip';

    final logId = await _backupRepo.logStart(
      location: 'drive',
      fileName: fileName,
      googleAccountEmail: email,
    );

    try {
      // 1. Get access token
      String accessToken;
      try {
        accessToken = await _authService.getValidAccessToken();
      } catch (e) {
        if (e is BackupException) rethrow;
        throw NetworkException('Could not authenticate with Google Drive: $e');
      }

      // 2. Prepare & compress
      _emitProgress(BackupStep.compressing, 0.20, 'Compressing database and configuration...');
      final zipBytes = await _createBackupZip();

      // 3. Resolve folder
      _emitProgress(BackupStep.connecting, 0.40, 'Connecting to Google Drive folder...');
      final folderId = await _getOrCreateBackupFolder(accessToken);

      // 4. Multipart upload
      _emitProgress(BackupStep.uploading, 0.60, 'Uploading backup archive to Google Drive...');
      final fileId = await _uploadMultipart(
        accessToken: accessToken,
        folderId: folderId,
        fileName: fileName,
        zipBytes: zipBytes,
      );

      // 5. Retention policy
      _emitProgress(BackupStep.pruning, 0.85, 'Applying retention policy (keeping last 14 backups)...');
      await _pruneOldBackups(accessToken, folderId);

      // 6. Log success
      await _backupRepo.logSuccess(id: logId, sizeBytes: zipBytes.length);
      _emitProgress(BackupStep.completed, 1.0, 'Backup completed successfully!');

      return fileId;
    } catch (e) {
      debugPrint('[GoogleDriveBackupService] Backup failed: $e');
      await _backupRepo.logFailure(id: logId, errorMessage: e.toString());
      _emitProgress(BackupStep.failed, 0.0, 'Backup failed: $e');
      rethrow;
    }
  }

  /// Executes multipart upload (JSON metadata + ZIP binary) to Drive API v3.
  Future<String> _uploadMultipart({
    required String accessToken,
    required String folderId,
    required String fileName,
    required Uint8List zipBytes,
  }) async {
    const boundary = 'SAJILO_BACKUP_BOUNDARY_7788';
    final uploadUri = Uri.https(
      'www.googleapis.com',
      '/upload/drive/v3/files',
      {'uploadType': 'multipart'},
    );

    final metadataJson = jsonEncode({
      'name': fileName,
      'parents': [folderId],
      'description': 'Sajilo Billing offline backup archive',
      'properties': {
        'app': 'sajilo_billing',
        'schema_version': '${_db.schemaVersion}',
      },
    });

    final metadataPart = utf8.encode(
      '--$boundary\r\n'
      'Content-Type: application/json; charset=UTF-8\r\n\r\n'
      '$metadataJson\r\n'
      '--$boundary\r\n'
      'Content-Type: application/zip\r\n\r\n',
    );

    final closingPart = utf8.encode('\r\n--$boundary--\r\n');

    final bodyBytes = Uint8List(
      metadataPart.length + zipBytes.length + closingPart.length,
    );
    bodyBytes.setRange(0, metadataPart.length, metadataPart);
    bodyBytes.setRange(
      metadataPart.length,
      metadataPart.length + zipBytes.length,
      zipBytes,
    );
    bodyBytes.setRange(
      metadataPart.length + zipBytes.length,
      bodyBytes.length,
      closingPart,
    );

    final response = await _httpClient.post(
      uploadUri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/related; boundary=$boundary',
        'Content-Length': '${bodyBytes.length}',
      },
      body: bodyBytes,
    );

    if (response.statusCode == 403 && response.body.contains('storageQuotaExceeded')) {
      throw const DriveStorageFullException();
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw NetworkException('Google Drive upload failed: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['id'] as String;
  }

  /// Enforces retention of at most [maxRetentionCount] latest backups.
  Future<void> _pruneOldBackups(String accessToken, String folderId) async {
    try {
      final listUri = Uri.https('www.googleapis.com', '/drive/v3/files', {
        'q': "'$folderId' in parents and trashed = false and name contains 'sajilo_billing_backup_'",
        'orderBy': 'createdTime desc',
        'fields': 'files(id, name, createdTime)',
        'pageSize': '100',
      });

      final response = await _httpClient.get(
        listUri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final files = data['files'] as List<dynamic>? ?? [];

      if (files.length > maxRetentionCount) {
        final toDelete = files.sublist(maxRetentionCount);
        for (final file in toDelete) {
          final fileId = file['id'] as String;
          final deleteUri = Uri.https('www.googleapis.com', '/drive/v3/files/$fileId');
          await _httpClient.delete(
            deleteUri,
            headers: {'Authorization': 'Bearer $accessToken'},
          );
          debugPrint('[GoogleDriveBackupService] Pruned old backup: ${file['name']}');
        }
      }
    } catch (e) {
      debugPrint('[GoogleDriveBackupService] Pruning error (ignored): $e');
    }
  }

  /// Fetches metadata summary of the latest backup stored on Google Drive
  /// without restoring it, for user confirmation in UI.
  Future<BackupMetadataSummary?> fetchLatestBackupSummary() async {
    final accessToken = await _authService.getValidAccessToken();
    final folderId = await _getOrCreateBackupFolder(accessToken);

    final listUri = Uri.https('www.googleapis.com', '/drive/v3/files', {
      'q': "'$folderId' in parents and trashed = false and name contains 'sajilo_billing_backup_'",
      'orderBy': 'createdTime desc',
      'fields': 'files(id, name, createdTime, size, properties)',
      'pageSize': '1',
    });

    final response = await _httpClient.get(
      listUri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw NetworkException('Failed to list backups: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final files = data['files'] as List<dynamic>? ?? [];
    if (files.isEmpty) return null;

    final latest = files.first as Map<String, dynamic>;
    final fileId = latest['id'] as String;
    final fileName = latest['name'] as String;
    final sizeBytes = int.tryParse(latest['size']?.toString() ?? '0') ?? 0;
    final createdAt = DateTime.tryParse(latest['createdTime']?.toString() ?? '') ?? DateTime.now();

    // Download and peek at settings.json
    final mediaUri = Uri.https('www.googleapis.com', '/drive/v3/files/$fileId', {'alt': 'media'});
    final mediaResponse = await _httpClient.get(
      mediaUri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (mediaResponse.statusCode != 200) {
      throw NetworkException('Failed to fetch backup content: ${mediaResponse.statusCode}');
    }

    final archive = ZipDecoder().decodeBytes(mediaResponse.bodyBytes);
    final settingsFile = archive.findFile('settings.json');
    if (settingsFile == null) {
      return BackupMetadataSummary(
        fileId: fileId,
        fileName: fileName,
        createdAt: createdAt,
        sizeBytes: sizeBytes,
        schemaVersion: 1,
        businessName: 'Sajilo Store',
        panNumber: '',
      );
    }

    final settingsJson = jsonDecode(utf8.decode(settingsFile.content as List<int>)) as Map<String, dynamic>;
    return BackupMetadataSummary.fromJson(
      settingsJson,
      fileId: fileId,
      fileName: fileName,
      sizeBytes: sizeBytes,
    );
  }

  @override
  Future<bool> restoreLatest([String? sourcePath]) async {
    _emitProgress(BackupStep.connecting, 0.10, 'Connecting to Google Drive...');
    final email = await _authService.getConnectedEmail();

    final logId = await _backupRepo.logStart(
      location: 'drive',
      fileName: 'restore_operation',
      googleAccountEmail: email,
    );

    try {
      Uint8List zipBytes;

      if (sourcePath != null && await File(sourcePath).exists()) {
        zipBytes = await File(sourcePath).readAsBytes();
      } else {
        final accessToken = await _authService.getValidAccessToken();
        final folderId = await _getOrCreateBackupFolder(accessToken);

        // Find newest backup file
        final listUri = Uri.https('www.googleapis.com', '/drive/v3/files', {
          'q': "'$folderId' in parents and trashed = false and name contains 'sajilo_billing_backup_'",
          'orderBy': 'createdTime desc',
          'fields': 'files(id, name, size)',
          'pageSize': '1',
        });

        final listResponse = await _httpClient.get(
          listUri,
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (listResponse.statusCode != 200) {
          throw NetworkException('Failed to locate backups: ${listResponse.body}');
        }

        final data = jsonDecode(listResponse.body) as Map<String, dynamic>;
        final files = data['files'] as List<dynamic>? ?? [];
        if (files.isEmpty) {
          throw const CorruptBackupException('No backups found in Google Drive folder.');
        }

        final latestFile = files.first as Map<String, dynamic>;
        final fileId = latestFile['id'] as String;

        _emitProgress(BackupStep.downloading, 0.35, 'Downloading latest backup archive...');
        final mediaUri = Uri.https('www.googleapis.com', '/drive/v3/files/$fileId', {'alt': 'media'});
        final mediaResponse = await _httpClient.get(
          mediaUri,
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (mediaResponse.statusCode != 200) {
          throw NetworkException('Failed to download backup: ${mediaResponse.statusCode}');
        }

        zipBytes = mediaResponse.bodyBytes;
      }

      // 1. Extract zip
      _emitProgress(BackupStep.extracting, 0.55, 'Extracting database from archive...');
      final archive = ZipDecoder().decodeBytes(zipBytes);

      final settingsFile = archive.findFile('settings.json');
      final dbArchiveFile = archive.findFile('database.sqlite');

      if (dbArchiveFile == null) {
        throw const CorruptBackupException('Archive does not contain database.sqlite.');
      }

      // 2. Validate schema compatibility
      _emitProgress(BackupStep.validating, 0.70, 'Validating schema compatibility...');
      if (settingsFile != null) {
        final settingsJson = jsonDecode(utf8.decode(settingsFile.content as List<int>)) as Map<String, dynamic>;
        final backupSchemaVersion = settingsJson['schema_version'] as int? ?? 1;
        if (backupSchemaVersion > _db.schemaVersion) {
          throw IncompatibleSchemaException(
            backupVersion: backupSchemaVersion,
            currentVersion: _db.schemaVersion,
          );
        }
      }

      // 3. Pre-restore safety backup
      _emitProgress(BackupStep.restoring, 0.80, 'Creating pre-restore safety copy...');
      final File currentDbFile = (await AppDatabase.getDatabaseFile()) as File;
      if (await currentDbFile.exists()) {
        final safetyTimestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        final safetyFile = File(
          p.join(
            currentDbFile.parent.path,
            'restored-overwrite-$safetyTimestamp.sqlite',
          ),
        );
        await currentDbFile.copy(safetyFile.path);
        debugPrint('[GoogleDriveBackupService] Created safety copy: ${safetyFile.path}');
      }

      // 4. Close database and overwrite
      _emitProgress(BackupStep.restoring, 0.90, 'Restoring database...');
      await _db.close();

      final targetDbBytes = dbArchiveFile.content as List<int>;
      await currentDbFile.writeAsBytes(targetDbBytes, flush: true);

      // Clean up WAL/SHM
      final walFile = File('${currentDbFile.path}-wal');
      final shmFile = File('${currentDbFile.path}-shm');
      if (await walFile.exists()) await walFile.delete();
      if (await shmFile.exists()) await shmFile.delete();

      await _backupRepo.logSuccess(id: logId, sizeBytes: zipBytes.length);
      _emitProgress(BackupStep.completed, 1.0, 'Database restored successfully!');
      return true;
    } catch (e) {
      debugPrint('[GoogleDriveBackupService] Restore failed: $e');
      await _backupRepo.logFailure(id: logId, errorMessage: e.toString());
      _emitProgress(BackupStep.failed, 0.0, 'Restore failed: $e');
      rethrow;
    }
  }

  void dispose() {
    _progressController.close();
  }
}
