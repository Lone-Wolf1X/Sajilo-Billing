import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../domain/backup_service.dart';
import 'backup_repository.dart';
import 'google_auth_service.dart';
import 'google_drive_backup_service.dart';
import 'local_backup_service.dart';

/// Available backup destinations.
enum BackupDestination {
  local,
  googleDrive,
}

/// Provider for backup audit repository.
final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BackupRepository(db);
});

/// Provider for Google authentication service.
final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

/// Provider for Local backup service.
final localBackupServiceProvider = Provider<LocalBackupService>((ref) {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(backupRepositoryProvider);
  return LocalBackupService(db, repo);
});

/// Provider for Google Drive backup service.
final googleDriveBackupServiceProvider = Provider<GoogleDriveBackupService>((ref) {
  final db = ref.watch(databaseProvider);
  final auth = ref.watch(googleAuthServiceProvider);
  final repo = ref.watch(backupRepositoryProvider);
  return GoogleDriveBackupService(
    db: db,
    authService: auth,
    backupRepo: repo,
  );
});

/// State notifier for user's chosen backup destination (defaults to [BackupDestination.local]).
class BackupDestinationNotifier extends StateNotifier<BackupDestination> {
  BackupDestinationNotifier() : super(BackupDestination.local);

  void setDestination(BackupDestination destination) {
    state = destination;
  }
}

final backupDestinationProvider =
    StateNotifierProvider<BackupDestinationNotifier, BackupDestination>((ref) {
  return BackupDestinationNotifier();
});

/// State notifier tracking signed-in Google account email.
class GoogleAccountNotifier extends StateNotifier<AsyncValue<String?>> {
  final GoogleAuthService _auth;

  GoogleAccountNotifier(this._auth) : super(const AsyncValue.loading()) {
    checkStatus();
  }

  Future<void> checkStatus() async {
    try {
      final signedIn = await _auth.isSignedIn();
      if (signedIn) {
        final email = await _auth.getConnectedEmail();
        state = AsyncValue.data(email);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<GoogleUserInfo> signIn({String? clientId, String? clientSecret}) async {
    state = const AsyncValue.loading();
    try {
      final user = await _auth.signIn(clientId: clientId, clientSecret: clientSecret);
      state = AsyncValue.data(user.email);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final googleAccountProvider =
    StateNotifierProvider<GoogleAccountNotifier, AsyncValue<String?>>((ref) {
  final auth = ref.watch(googleAuthServiceProvider);
  return GoogleAccountNotifier(auth);
});

/// Resolves active backup service based on chosen destination.
final activeBackupServiceProvider = Provider<BackupService>((ref) {
  final destination = ref.watch(backupDestinationProvider);
  final accountState = ref.watch(googleAccountProvider);

  if (destination == BackupDestination.googleDrive && accountState.value != null) {
    return ref.watch(googleDriveBackupServiceProvider);
  }
  return ref.watch(localBackupServiceProvider);
});

/// Stream of recent backup logs for audit display.
final recentBackupLogsProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(backupRepositoryProvider);
  return repo.watchRecentLogs(limit: 20);
});

