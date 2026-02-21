import 'package:mineral/api.dart';

final class ActionMetadata {
  final Snowflake channelId;
  final int duration;
  final String? customMessage;

  ActionMetadata({
    required this.channelId,
    required this.duration,
    this.customMessage,
  });

  factory ActionMetadata.fromJson(Map<String, dynamic> json) {
    return ActionMetadata(
      channelId: json['channel_id'],
      duration: json['duration_seconds'],
      customMessage: json['custom_message'],
    );
  }
}