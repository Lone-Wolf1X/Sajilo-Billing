import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/core/database/app_database.dart';
import 'package:sajilo_billing/core/platform/secure_token_store_web.dart';
import 'package:sajilo_billing/features/auth/data/local_auth_repository.dart';

void main() {
  late AppDatabase db;
  late SecureTokenStoreWeb tokenStore;
  late LocalAuthRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tokenStore = SecureTokenStoreWeb();
    repo = LocalAuthRepository(db, tokenStore);
  });

  tearDown(() async {
    await db.close();
  });

  group('LocalAuthRepository Tests', () {
    test('Initial database has no local accounts', () async {
      expect(await repo.hasLocalAccount(), isFalse);
      expect(await repo.hasActiveSession(), isFalse);
    });

    test('Creating a local account hashes password and security answer with salt', () async {
      final user = await repo.createLocalAccount(
        username: 'shopkeeper1',
        password: 'password123',
        securityQuestion: 'What is your primary school name?',
        securityAnswer: 'Shree Krishna School',
        displayName: 'Ram Shrestha',
      );

      expect(user.username, equals('shopkeeper1'));
      expect(user.displayName, equals('Ram Shrestha'));
      expect(user.passwordSalt, isNotEmpty);
      expect(user.passwordHash, isNot(contains('password123')));
      expect(user.securityAnswerHash, isNot(contains('Krishna')));
      expect(await repo.hasLocalAccount(), isTrue);
    });

    test('Duplicate username is rejected', () async {
      await repo.createLocalAccount(
        username: 'cashier',
        password: 'secretPassword',
        securityAnswer: 'Dog',
      );

      await expectLater(
        repo.createLocalAccount(
          username: 'CASHIER', // Case-insensitive check
          password: 'anotherPassword',
          securityAnswer: 'Cat',
        ),
        throwsA(isA<LocalAuthException>()),
      );
    });

    test('Login with valid credentials creates active session', () async {
      await repo.createLocalAccount(
        username: 'ramesh',
        password: 'nepalRetailPassword',
        securityAnswer: 'Pokhara',
      );

      final loggedIn = await repo.login(
        username: 'ramesh',
        password: 'nepalRetailPassword',
      );

      expect(loggedIn.username, equals('ramesh'));
      expect(await repo.hasActiveSession(), isTrue);
      expect(await repo.getActiveUsername(), equals('ramesh'));
    });

    test('Invalid password increments failed attempts and locks out after 5 failures', () async {
      await repo.createLocalAccount(
        username: 'sita',
        password: 'correctPassword',
        securityAnswer: 'Momo',
      );

      // Attempts 1 to 4 should fail with remaining attempt warning
      for (int i = 1; i <= 4; i++) {
        await expectLater(
          repo.login(username: 'sita', password: 'wrongPassword$i'),
          throwsA(predicate((e) => e is LocalAuthException && e.message.contains('attempts remaining'))),
        );
      }

      // 5th failed attempt triggers 5-minute lockout
      await expectLater(
        repo.login(username: 'sita', password: 'wrongPassword5'),
        throwsA(predicate((e) => e is LocalAuthException && e.message.contains('locked for 5 minutes'))),
      );

      // 6th attempt (even with correct password) must remain locked out
      await expectLater(
        repo.login(username: 'sita', password: 'correctPassword'),
        throwsA(predicate((e) => e is LocalAuthException && e.message.contains('Account locked'))),
      );
    });

    test('Password reset via valid security answer updates password and enables login', () async {
      await repo.createLocalAccount(
        username: 'hari',
        password: 'oldPassword1',
        securityQuestion: 'What is your favorite Nepali dish?',
        securityAnswer: 'Dal Bhat Power',
      );

      // Verify wrong answer throws
      await expectLater(
        repo.resetPassword(
          username: 'hari',
          securityAnswer: 'Chowmein',
          newPassword: 'newBrandNewPassword',
        ),
        throwsA(predicate((e) => e is LocalAuthException && e.message.contains('Incorrect security answer'))),
      );

      // Reset with correct answer
      await repo.resetPassword(
        username: 'hari',
        securityAnswer: 'Dal bhat power', // Case-insensitive normalization
        newPassword: 'newBrandNewPassword',
      );

      // Old password must fail
      await expectLater(
        repo.login(username: 'hari', password: 'oldPassword1'),
        throwsA(isA<LocalAuthException>()),
      );

      // New password succeeds
      final user = await repo.login(username: 'hari', password: 'newBrandNewPassword');
      expect(user.username, equals('hari'));
    });

    test('Logout clears session token and active username', () async {
      await repo.createLocalAccount(
        username: 'anil',
        password: 'password2026',
        securityAnswer: 'Answer',
      );

      await repo.login(username: 'anil', password: 'password2026');
      expect(await repo.hasActiveSession(), isTrue);

      await repo.logout();
      expect(await repo.hasActiveSession(), isFalse);
      expect(await repo.getActiveUsername(), isNull);
    });
  });
}
