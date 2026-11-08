/// Represents discrete steps during backup or restore.
enum BackupStep {
  idle,
  preparing,
  compressing,
  connecting,
  uploading,
  downloading,
  extracting,
  validating,
  restoring,
  pruning,
  completed,
  failed,
}

/// Progress updates emitted during backup or restore operations.
class BackupProgress {
  final BackupStep step;
  final double percentage; // 0.0 to 1.0
  final String message;

  const BackupProgress({
    required this.step,
    required this.percentage,
    required this.message,
  });

  @override
  String toString() => 'BackupProgress($step, ${(percentage * 100).toStringAsFixed(0)}%, $message)';
}
