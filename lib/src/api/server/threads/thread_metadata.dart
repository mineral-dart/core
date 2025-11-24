final class ThreadMetadata {
  final bool isArchived;
  final int? autoArchiveDuration;
  final bool isLocked;
  final DateTime? archiveTimestamp;
  final bool isPublic;

  ThreadMetadata({
    required this.isArchived,
    required this.autoArchiveDuration,
    required this.isLocked,
    this.isPublic = true,
    this.archiveTimestamp,
  });

  factory ThreadMetadata.fromMap(Map<String, dynamic> json) {
    return ThreadMetadata(
      isArchived: bool.parse(json['archived'] ?? 'false'),
      autoArchiveDuration: json['auto_archive_duration'],
      isLocked: bool.parse(json['locked'] ?? 'false'),
      archiveTimestamp: json['archive_timestamp'] != null
          ? DateTime.parse(json['archive_timestamp'])
          : null,
    );
  }
}
