import 'package:mineral/src/api/common/types/channel_type.dart';

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

  factory ThreadMetadata.serialize(
      Map<String, dynamic> json, ChannelType type) {
    return ThreadMetadata(
      archived: json['archived'],
      autoArchiveDuration: json['auto_archive_duration'],
      locked: json['locked'],
      isPublic: type == ChannelType.guildPublicThread,
      invitable: json['invitable'],
      archiveTimestamp: json['archive_timestamp'] != null
          ? DateTime.parse(json['archive_timestamp'])
          : null,
    );
  }
}
