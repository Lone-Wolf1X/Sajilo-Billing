import 'package:flutter/foundation.dart';

@immutable
class SyncStateModel {
  final bool isSyncing;
  final bool isPaused;
  final DateTime? lastSyncedAt;
  final String? errorMessage;
  final int pendingLocalChanges;

  const SyncStateModel({
    this.isSyncing = false,
    this.isPaused = false,
    this.lastSyncedAt,
    this.errorMessage,
    this.pendingLocalChanges = 0,
  });

  SyncStateModel copyWith({
    bool? isSyncing,
    bool? isPaused,
    DateTime? lastSyncedAt,
    String? errorMessage,
    int? pendingLocalChanges,
  }) {
    return SyncStateModel(
      isSyncing: isSyncing ?? this.isSyncing,
      isPaused: isPaused ?? this.isPaused,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingLocalChanges: pendingLocalChanges ?? this.pendingLocalChanges,
    );
  }
}

