import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to monitor online/offline connectivity on Desktop and Mobile.
class ConnectivityWatcher {
  final Connectivity _connectivity;

  ConnectivityWatcher({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Returns true if an active network connection exists.
  Future<bool> isConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _hasActiveConnection(results);
    } catch (_) {
      // Conservative default: assume connected if check fails so user is not blocked
      return true;
    }
  }

  /// Real-time stream of network connection status.
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasActiveConnection);
  }

  static bool _hasActiveConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    for (final r in results) {
      if (r != ConnectivityResult.none) {
        return true;
      }
    }
    return false;
  }
}

final connectivityWatcherProvider = Provider<ConnectivityWatcher>((ref) {
  return ConnectivityWatcher();
});

final isOnlineStreamProvider = StreamProvider<bool>((ref) {
  final watcher = ref.watch(connectivityWatcherProvider);
  return watcher.onConnectivityChanged;
});

final isOnlineFutureProvider = FutureProvider<bool>((ref) async {
  final watcher = ref.watch(connectivityWatcherProvider);
  return await watcher.isConnected();
});

