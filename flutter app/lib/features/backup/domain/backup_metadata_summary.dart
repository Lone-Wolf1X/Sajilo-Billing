/// Metadata summary for displaying backup information in restore dialogs.
class BackupMetadataSummary {
  final String fileId;
  final String fileName;
  final DateTime createdAt;
  final int sizeBytes;
  final int schemaVersion;
  final String businessName;
  final String panNumber;

  const BackupMetadataSummary({
    required this.fileId,
    required this.fileName,
    required this.createdAt,
    required this.sizeBytes,
    required this.schemaVersion,
    required this.businessName,
    required this.panNumber,
  });

  factory BackupMetadataSummary.fromJson(Map<String, dynamic> json, {String fileId = '', String fileName = '', int sizeBytes = 0}) {
    return BackupMetadataSummary(
      fileId: fileId,
      fileName: fileName,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      sizeBytes: sizeBytes,
      schemaVersion: json['schema_version'] as int? ?? 1,
      businessName: json['business_name'] as String? ?? 'Unknown Shop',
      panNumber: json['pan_number'] as String? ?? '',
    );
  }
}

