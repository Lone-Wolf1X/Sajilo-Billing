/// Sync status enum for offline-first architecture.
/// Every table includes this status so records can be queued and synced
/// to a remote backend in future phases without schema migrations.
enum SyncStatus {
  pending,
  synced,
  failed;

  String get label {
    switch (this) {
      case SyncStatus.pending:
        return 'Pending';
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.failed:
        return 'Failed';
    }
  }
}

