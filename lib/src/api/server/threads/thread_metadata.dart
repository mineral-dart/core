final class ThreadMetadata {
  final bool archived;
  final int? autoArchiveDuration;
  final bool locked;
  final DateTime? archiveTimestamp;
  final bool isPublic;

  ThreadMetadata({
    required this.archived,
    required this.autoArchiveDuration,
    required this.locked,
    this.isPublic = true,
    this.archiveTimestamp,
  });

  factory ThreadMetadata.fromMap(Map<String, dynamic> json) {
    return ThreadMetadata(
      archived: bool.parse(json['archived'] ?? 'false'),
      autoArchiveDuration: json['auto_archive_duration'],
      locked: bool.parse(json['locked'] ?? 'false'),
      archiveTimestamp: json['archive_timestamp'] != null
          ? DateTime.parse(json['archive_timestamp'])
          : null,
    );
  }
}
