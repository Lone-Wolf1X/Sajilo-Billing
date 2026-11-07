/// Abstract contract for local and future cloud database backups.
abstract class BackupService {
  /// Exports or backs up the database archive.
  /// Returns the destination path or identifier of the created backup.
  Future<String> backupNow({String? targetDirectoryPath});

  /// Restores the database from an archive file.
  /// If [sourcePath] is not specified, prompts the user via desktop file selector.
  Future<bool> restoreLatest([String? sourcePath]);

  /// Returns the timestamp of the last recorded successful backup, or null.
  Future<DateTime?> getLastBackupTime();
}
