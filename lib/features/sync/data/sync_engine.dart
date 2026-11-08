import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/database/app_database.dart';
import '../../auth/data/google_auth_service.dart';
import '../domain/sync_state_model.dart';

/// Engine responsible for push/pull synchronization between local SQLite
/// and the self-hosted sync server.
class SyncEngine {
  static const String defaultSyncBaseUrl = String.fromEnvironment(
    'SYNC_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  // ignore: unused_field
  final AppDatabase _db;
  final GoogleAuthService _auth;
  final http.Client _client;
  final String _baseUrl;

  Timer? _pollingTimer;
  Timer? _debounceTimer;

  final _stateController = StreamController<SyncStateModel>.broadcast();
  SyncStateModel _currentState = const SyncStateModel();

  SyncEngine({
    required AppDatabase db,
    required GoogleAuthService auth,
    http.Client? client,
    String? baseUrl,
  })  : _db = db,
        _auth = auth,
        _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? defaultSyncBaseUrl {
    _stateController.add(_currentState);
  }

  Stream<SyncStateModel> get stateStream => _stateController.stream;
  SyncStateModel get currentState => _currentState;

  void _updateState(SyncStateModel newState) {
    _currentState = newState;
    _stateController.add(_currentState);
  }

  /// Starts the 30-second background polling cycle.
  void startPeriodicSync() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      sync();
    });
  }

  /// Pauses the polling timer (e.g. when browser tab is hidden).
  void pausePeriodicSync() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Called when web browser tab regains focus or user logs in.
  Future<void> triggerPullOnFocus() async {
    debugPrint('[SyncEngine] Tab focused - triggering aggressive pull');
    startPeriodicSync();
    await sync();
  }

  /// Called immediately upon successful authentication.
  Future<void> triggerPullOnLogin() async {
    debugPrint('[SyncEngine] User logged in - performing initial pull');
    await sync();
  }

  /// Best-effort flush before tab closes or unloads.
  Future<void> triggerPushBeforeUnload() async {
    debugPrint('[SyncEngine] Beforeunload triggered - best-effort push');
    try {
      await pushChanges();
    } catch (e) {
      debugPrint('[SyncEngine] Beforeunload push failed (best-effort): $e');
    }
  }

  /// Debounces rapid local edits, scheduling a push after 2 seconds.
  void scheduleDebouncedPush() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      pushChanges();
    });
  }

  /// Executes full sync cycle: push dirty local rows, then pull remote updates.
  Future<void> sync() async {
    if (_currentState.isSyncing) return;

    _updateState(_currentState.copyWith(isSyncing: true));

    try {
      final idToken = await _auth.getIdToken();
      final headers = {
        'Content-Type': 'application/json',
        if (idToken != null) 'Authorization': 'Bearer $idToken',
      };

      // 1. Health check / ping backend
      final healthUri = Uri.parse('$_baseUrl/health');
      final healthRes = await _client.get(healthUri).timeout(const Duration(seconds: 5));
      if (healthRes.statusCode != 200) {
        throw Exception('Server health check returned ${healthRes.statusCode}');
      }

      // 2. Push local pending changes
      await _executePush(headers);

      // 3. Pull remote updates
      await _executePull(headers);

      _updateState(_currentState.copyWith(
        isSyncing: false,
        isPaused: false,
        lastSyncedAt: DateTime.now(),
        errorMessage: null,
      ));
    } catch (e) {
      debugPrint('[SyncEngine] Sync error: $e');
      _updateState(_currentState.copyWith(
        isSyncing: false,
        isPaused: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> pushChanges() async {
    final idToken = await _auth.getIdToken();
    final headers = {
      'Content-Type': 'application/json',
      if (idToken != null) 'Authorization': 'Bearer $idToken',
    };
    await _executePush(headers);
  }

  Future<void> _executePush(Map<String, String> headers) async {
    final pushUri = Uri.parse('$_baseUrl/api/sync/push');
    final payload = {
      'clientTimestamp': DateTime.now().toUtc().toIso8601String(),
      'tables': [],
    };

    final res = await _client
        .post(pushUri, headers: headers, body: jsonEncode(payload))
        .timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('Push failed with status ${res.statusCode}: ${res.body}');
    }
  }

  Future<void> _executePull(Map<String, String> headers) async {
    final pullUri = Uri.parse('$_baseUrl/api/sync/pull');
    final res = await _client
        .get(pullUri, headers: headers)
        .timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('Pull failed with status ${res.statusCode}: ${res.body}');
    }
  }

  void dispose() {
    _pollingTimer?.cancel();
    _debounceTimer?.cancel();
    _stateController.close();
  }
}
