import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../backup/data/backup_service_locator.dart';
import '../data/google_auth_service.dart';
import '../data/local_auth_repository.dart';

enum AuthStatus {
  splash,
  unauthenticated,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final String? username;
  final String? email;
  final bool isGoogleAuth;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    required this.status,
    this.username,
    this.email,
    this.isGoogleAuth = false,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? username,
    String? email,
    bool? isGoogleAuth,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      isGoogleAuth: isGoogleAuth ?? this.isGoogleAuth,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LocalAuthRepository _localRepo;
  final GoogleAuthService _googleAuth;

  AuthNotifier({
    required LocalAuthRepository localRepo,
    required GoogleAuthService googleAuth,
  })  : _localRepo = localRepo,
        _googleAuth = googleAuth,
        super(const AuthState(status: AuthStatus.splash));

  Future<void> checkInitialSession() async {
    // 1. Check persistent local session
    final hasSession = await _localRepo.hasActiveSession();
    if (hasSession) {
      final username = await _localRepo.getActiveUsername();
      state = AuthState(
        status: AuthStatus.authenticated,
        username: username ?? 'Shopkeeper',
        isGoogleAuth: false,
      );
      return;
    }

    // 2. Check Google Auth session
    final isGoogleSignedIn = await _googleAuth.isSignedIn();
    if (isGoogleSignedIn) {
      final email = await _googleAuth.getConnectedEmail();
      final name = await _googleAuth.getConnectedName();
      state = AuthState(
        status: AuthStatus.authenticated,
        username: name ?? 'Google User',
        email: email,
        isGoogleAuth: true,
      );
      return;
    }

    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> loginLocal({required String username, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _localRepo.login(username: username, password: password);
      state = AuthState(
        status: AuthStatus.authenticated,
        username: user.displayName ?? user.username,
        isGoogleAuth: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> loginGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _googleAuth.signIn();
      state = AuthState(
        status: AuthStatus.authenticated,
        username: user.name,
        email: user.email,
        isGoogleAuth: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> createAccount({
    required String username,
    required String password,
    required String securityQuestion,
    required String securityAnswer,
    String? displayName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _localRepo.createLocalAccount(
        username: username,
        password: password,
        securityQuestion: securityQuestion,
        securityAnswer: securityAnswer,
        displayName: displayName,
      );
      // Automatically log in after creating account
      return await loginLocal(username: username, password: password);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> registerLocal({
    required String username,
    required String password,
    required String securityQuestion,
    required String securityAnswer,
    String? displayName,
  }) async {
    return createAccount(
      username: username,
      password: password,
      securityQuestion: securityQuestion,
      securityAnswer: securityAnswer,
      displayName: displayName,
    );
  }

  Future<bool> resetPasswordLocal({
    required String username,
    required String securityAnswer,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _localRepo.resetPassword(
        username: username,
        securityAnswer: securityAnswer,
        newPassword: newPassword,
      );
      state = state.copyWith(isLoading: false, errorMessage: null);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _localRepo.logout();
    if (state.isGoogleAuth) {
      await _googleAuth.signOut();
    }
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final localRepo = ref.watch(localAuthRepositoryProvider);
  final googleAuth = ref.watch(googleAuthServiceProvider);
  return AuthNotifier(localRepo: localRepo, googleAuth: googleAuth);
});
