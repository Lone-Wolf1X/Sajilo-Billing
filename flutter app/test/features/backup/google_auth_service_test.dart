import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/features/backup/data/google_auth_service.dart';
import 'package:sajilo_billing/features/backup/domain/backup_error.dart';

void main() {
  group('GoogleAuthService PKCE & Security Tests', () {
    test('generateCodeVerifier creates high-entropy URL-safe strings', () {
      final verifier1 = GoogleAuthService.generateCodeVerifier(64);
      final verifier2 = GoogleAuthService.generateCodeVerifier(64);

      expect(verifier1.length, equals(64));
      expect(verifier2.length, equals(64));
      expect(verifier1, isNot(equals(verifier2)));

      // Verifier must only contain unreserved characters: [A-Z], [a-z], [0-9], "-", ".", "_", "~"
      final regex = RegExp(r'^[A-Za-z0-9\-\._~]{43,128}$');
      expect(regex.hasMatch(verifier1), isTrue);
      expect(regex.hasMatch(verifier2), isTrue);
    });

    test('generateCodeChallenge generates valid unpadded S256 challenge', () {
      const knownVerifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
      final challenge = GoogleAuthService.generateCodeChallenge(knownVerifier);

      // Verify no padding character '='
      expect(challenge.contains('='), isFalse);

      // Verify calculation manually: Base64UrlEncode(SHA256(ASCII(verifier)))
      final manualBytes = ascii.encode(knownVerifier);
      final manualHash = sha256.convert(manualBytes);
      final manualChallenge = base64Url.encode(manualHash.bytes).replaceAll('=', '');

      expect(challenge, equals(manualChallenge));
    });

    test('redactToken masks sensitive token values for safe logging', () {
      expect(GoogleAuthService.redactToken(null), equals('null'));
      expect(GoogleAuthService.redactToken(''), equals('null'));
      expect(GoogleAuthService.redactToken('short'), equals('***'));
      expect(
        GoogleAuthService.redactToken('ya29.a0AXooCgu8734hksdjfhkasdjf89234'),
        equals('ya29...9234'),
      );
    });

    test('Typed backup exceptions format descriptive messages', () {
      const cancelEx = UserCancelledException('User closed browser');
      expect(cancelEx.toString(), contains('User closed browser'));

      const networkEx = NetworkException('Connection reset');
      expect(networkEx.toString(), contains('Connection reset'));

      const revokedEx = AuthRevokedException();
      expect(revokedEx.toString(), contains('revoked'));

      const schemaEx = IncompatibleSchemaException(backupVersion: 5, currentVersion: 3);
      expect(schemaEx.backupVersion, equals(5));
      expect(schemaEx.currentVersion, equals(3));
      expect(schemaEx.toString(), contains('schema version (5) is incompatible with current app version (3)'));
    });
  });
}

