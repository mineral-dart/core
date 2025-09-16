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
}