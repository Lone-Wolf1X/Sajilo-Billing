import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/sync_status.dart';
import '../../../core/platform/secure_token_store.dart';

class LocalAuthException implements Exception {
  final String message;
  const LocalAuthException(this.message);

  @override
  String toString() => message;
}

class LocalAuthRepository {
  static const String _kSessionTokenKey = 'sajilo_session_token';
  static const String _kLoggedUserKey = 'sajilo_logged_username';
  static const int _maxFailedAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 5);

  final AppDatabase _db;
  final SecureTokenStore _tokenStore;
  final _uuid = const Uuid();

  LocalAuthRepository(this._db, [SecureTokenStore? tokenStore])
      : _tokenStore = tokenStore ?? SecureTokenStore.create();

  /// Generates a cryptographically random salt.
  static String _generateSalt([int length = 32]) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Hashes a password or answer with SHA-256 and salt.
  static String hashWithSalt(String input, String salt) {
    final key = utf8.encode(salt);
    final bytes = utf8.encode(input.trim());
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }

  /// Checks if any local user account has been created yet.
  Future<bool> hasLocalAccount() async {
    final count = await (_db.selectOnly(_db.localAuth)
          ..addColumns([_db.localAuth.id.count()])
          ..where(_db.localAuth.isDeleted.equals(false)))
        .getSingle();
    return (count.read(_db.localAuth.id.count()) ?? 0) > 0;
  }

  /// Creates a new local credentials account.
  Future<LocalAuthData> createLocalAccount({
    required String username,
    required String password,
    String securityQuestion = 'What is your shop name?',
    required String securityAnswer,
    String? displayName,
  }) async {
    final cleanUsername = username.trim().toLowerCase();
    if (cleanUsername.isEmpty) {
      throw const LocalAuthException('Username cannot be empty.');
    }
    if (password.length < 4) {
      throw const LocalAuthException('Password must be at least 4 characters long.');
    }

    final existing = await (_db.select(_db.localAuth)
          ..where((tbl) => tbl.username.equals(cleanUsername) & tbl.isDeleted.equals(false))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      throw const LocalAuthException('Username is already taken.');
    }

    final salt = _generateSalt();
    final passwordHash = hashWithSalt(password, salt);
    final answerHash = hashWithSalt(securityAnswer.toLowerCase(), salt);

    final now = DateTime.now().toUtc();
    final newId = _uuid.v4();

    await _db.into(_db.localAuth).insert(
          LocalAuthCompanion(
            id: Value(newId),
            username: Value(cleanUsername),
            passwordHash: Value(passwordHash),
            passwordSalt: Value(salt),
            securityQuestion: Value(securityQuestion),
            securityAnswerHash: Value(answerHash),
            failedAttempts: const Value(0),
            displayName: Value(displayName?.trim()),
            createdAt: Value(now),
            updatedAt: Value(now),
            syncStatus: const Value(SyncStatus.synced), // local-only
          ),
        );

    return await (_db.select(_db.localAuth)..where((tbl) => tbl.id.equals(newId))).getSingle();
  }

  /// Authenticates a local user with rate-limiting lock after 5 failed attempts.
  Future<LocalAuthData> login({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim().toLowerCase();
    final user = await (_db.select(_db.localAuth)
          ..where((tbl) => tbl.username.equals(cleanUsername) & tbl.isDeleted.equals(false))
          ..limit(1))
        .getSingleOrNull();

    if (user == null) {
      throw const LocalAuthException('Invalid username or password.');
    }

    // Check account lockout
    final now = DateTime.now().toUtc();
    if (user.lockedUntil != null && user.lockedUntil!.isAfter(now)) {
      final remaining = user.lockedUntil!.difference(now).inMinutes + 1;
      throw LocalAuthException('Too many failed attempts. Account locked for $remaining more minutes.');
    }

    final computedHash = hashWithSalt(password, user.passwordSalt);
    if (computedHash != user.passwordHash) {
      final newAttempts = user.failedAttempts + 1;
      final shouldLock = newAttempts >= _maxFailedAttempts;

      await (_db.update(_db.localAuth)..where((tbl) => tbl.id.equals(user.id))).write(
        LocalAuthCompanion(
          failedAttempts: Value(newAttempts),
          lockedUntil: Value(shouldLock ? now.add(_lockoutDuration) : null),
          updatedAt: Value(now),
        ),
      );

      if (shouldLock) {
        throw const LocalAuthException('5 failed attempts reached. Account locked for 5 minutes.');
      }
      throw LocalAuthException('Invalid username or password. (${_maxFailedAttempts - newAttempts} attempts remaining)');
    }

    // Login successful - reset failed attempts and generate session token
    await (_db.update(_db.localAuth)..where((tbl) => tbl.id.equals(user.id))).write(
      LocalAuthCompanion(
        failedAttempts: const Value(0),
        lockedUntil: const Value(null),
        updatedAt: Value(now),
      ),
    );

    final sessionToken = _uuid.v4();
    await _tokenStore.write(key: _kSessionTokenKey, value: sessionToken);
    await _tokenStore.write(key: _kLoggedUserKey, value: cleanUsername);

    return user;
  }

  /// Resets password by verifying security answer.
  Future<void> resetPassword({
    required String username,
    required String securityAnswer,
    required String newPassword,
  }) async {
    final cleanUsername = username.trim().toLowerCase();
    final user = await (_db.select(_db.localAuth)
          ..where((tbl) => tbl.username.equals(cleanUsername) & tbl.isDeleted.equals(false))
          ..limit(1))
        .getSingleOrNull();

    if (user == null) {
      throw const LocalAuthException('User account not found.');
    }

    if (newPassword.length < 4) {
      throw const LocalAuthException('New password must be at least 4 characters long.');
    }

    final computedAnswerHash = hashWithSalt(securityAnswer.toLowerCase(), user.passwordSalt);
    if (computedAnswerHash != user.securityAnswerHash) {
      throw const LocalAuthException('Incorrect security answer.');
    }

    // Reset password with fresh salt
    final newSalt = _generateSalt();
    final newPasswordHash = hashWithSalt(newPassword, newSalt);
    final newAnswerHash = hashWithSalt(securityAnswer.toLowerCase(), newSalt);
    final now = DateTime.now().toUtc();

    await (_db.update(_db.localAuth)..where((tbl) => tbl.id.equals(user.id))).write(
      LocalAuthCompanion(
        passwordHash: Value(newPasswordHash),
        passwordSalt: Value(newSalt),
        securityAnswerHash: Value(newAnswerHash),
        failedAttempts: const Value(0),
        lockedUntil: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  /// Retrieves the security question for a user.
  Future<String?> getSecurityQuestion(String username) async {
    final cleanUsername = username.trim().toLowerCase();
    final user = await (_db.select(_db.localAuth)
          ..where((tbl) => tbl.username.equals(cleanUsername) & tbl.isDeleted.equals(false))
          ..limit(1))
        .getSingleOrNull();
    return user?.securityQuestion;
  }

  /// Checks if a valid persistent session exists.
  Future<bool> hasActiveSession() async {
    final token = await _tokenStore.read(key: _kSessionTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Returns the username of currently logged-in user.
  Future<String?> getActiveUsername() async {
    return await _tokenStore.read(key: _kLoggedUserKey);
  }

  /// Logs out the user by clearing session tokens (data remains safe in SQLite).
  Future<void> logout() async {
    await _tokenStore.delete(key: _kSessionTokenKey);
    await _tokenStore.delete(key: _kLoggedUserKey);
  }
}

final localAuthRepositoryProvider = Provider<LocalAuthRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LocalAuthRepository(db);
});

