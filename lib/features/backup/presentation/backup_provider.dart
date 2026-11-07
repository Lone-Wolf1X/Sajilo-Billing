import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../data/local_backup_service.dart';
import '../domain/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(databaseProvider);
  return LocalBackupService(db);
});

final lastBackupTimeProvider = FutureProvider<DateTime?>((ref) async {
  final service = ref.watch(backupServiceProvider);
  return service.getLastBackupTime();
});

