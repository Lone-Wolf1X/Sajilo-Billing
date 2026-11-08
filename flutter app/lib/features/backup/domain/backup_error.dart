/// Typed exceptions for Google Drive and Local backup & restore operations.
abstract class BackupException implements Exception {
  final String message;
  final dynamic cause;

  const BackupException(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Thrown when the user cancels the OAuth browser prompt or file dialog.
class UserCancelledException extends BackupException {
  const UserCancelledException([super.message = 'Operation was cancelled by user']);
}

/// Thrown when network is unreachable or API request times out.
class NetworkException extends BackupException {
  const NetworkException([super.message = 'Network is unavailable or request timed out', super.cause]);
}

/// Thrown when the user's refresh token is invalid or revoked by Google.
class AuthRevokedException extends BackupException {
  const AuthRevokedException([super.message = 'Google authorization has been revoked or expired. Please sign in again.']);
}

/// Thrown when Google Client ID / Secret configuration is missing.
class OAuthConfigurationException extends BackupException {
  const OAuthConfigurationException([super.message = 'Google OAuth credentials are not configured.']);
}

/// Thrown when the Sajilo Billing backup folder could not be found or created.
class DriveFolderNotFoundException extends BackupException {
  const DriveFolderNotFoundException([super.message = 'Could not locate or create backup folder in Google Drive']);
}

/// Thrown when a backup archive has a newer or incompatible SQLite schema version.
class IncompatibleSchemaException extends BackupException {
  final int backupVersion;
  final int currentVersion;

  const IncompatibleSchemaException({
    required this.backupVersion,
    required this.currentVersion,
    String? message,
  }) : super(message ??
            'Backup database schema version ($backupVersion) is incompatible with current app version ($currentVersion). Update the app to restore this backup.');
}

/// Thrown when Google Drive storage quota is exceeded.
class DriveStorageFullException extends BackupException {
  const DriveStorageFullException([super.message = 'Google Drive storage quota exceeded']);
}

/// Thrown when a backup zip is corrupted or missing database/metadata.
class CorruptBackupException extends BackupException {
  const CorruptBackupException([super.message = 'Backup archive is corrupt or missing required files']);
}
