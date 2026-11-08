import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_billing/features/auth/data/google_auth_service_web.dart';
import 'package:sajilo_billing/features/backup/domain/backup_error.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleAuthServiceWeb Tests', () {
    test('signIn returns user info and sets in-memory tokens', () async {
      final auth = GoogleAuthServiceWeb();

      expect(await auth.isSignedIn(), isFalse);

      final user = await auth.signIn(clientId: 'test-web-client-id');
      expect(user.email, isNotEmpty);
      expect(user.name, isNotEmpty);

      expect(await auth.isSignedIn(), isTrue);
      expect(await auth.getConnectedEmail(), equals(user.email));
      expect(await auth.getIdToken(), isNotNull);

      final accessToken = await auth.getValidAccessToken();
      expect(accessToken, isNotEmpty);
    });

    test('signOut clears in-memory state and tokens', () async {
      final auth = GoogleAuthServiceWeb();
      await auth.signIn(clientId: 'test-web-client-id');
      expect(await auth.isSignedIn(), isTrue);

      await auth.signOut();
      expect(await auth.isSignedIn(), isFalse);
      expect(await auth.getConnectedEmail(), isNull);
      expect(await auth.getIdToken(), isNull);
    });

    test('Missing client ID throws OAuthConfigurationException', () async {
      final auth = GoogleAuthServiceWeb();
      expect(
        () => auth.signIn(clientId: ''),
        throwsA(isA<OAuthConfigurationException>()),
      );
    });

    test('getValidAccessToken throws AuthRevokedException when not signed in', () async {
      final auth = GoogleAuthServiceWeb();
      expect(
        () => auth.getValidAccessToken(),
        throwsA(isA<AuthRevokedException>()),
      );
    });
  });
}
