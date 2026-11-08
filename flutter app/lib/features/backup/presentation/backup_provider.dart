import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backup_service_locator.dart';
import '../domain/backup_service.dart';

/// Legacy export pointing to active backup service
final backupServiceProvider = Provider<BackupService>((ref) {
  return ref.watch(activeBackupServiceProvider);
});

/// Future provider tracking last backup time from active service
final lastBackupTimeProvider = FutureProvider<DateTime?>((ref) async {
  final service = ref.watch(activeBackupServiceProvider);
  return service.getLastBackupTime();
});
