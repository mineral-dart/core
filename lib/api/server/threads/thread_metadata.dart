final class ThreadMetadata {
  final bool archived;
  final int autoArchiveDuration;
  final bool locked;
  final bool? invitable;
  final DateTime? archiveTimestamp;
  final bool isPublic;

  ThreadMetadata({
    required this.archived,
    required this.autoArchiveDuration,
    required this.locked,
    this.isPublic = true,
    this.invitable,
    this.archiveTimestamp,
  });
}