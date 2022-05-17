import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/constants.dart';

class TextBasedChannel extends Channel {
  String? description;
  bool nsfw;
  Snowflake? lastMessageId;
  DateTime? lastPin;

  TextBasedChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required this.description,
    required this.nsfw,
    required this.lastMessageId,
    required this.lastPin,
  }) : super(
    id: id,
    type: ChannelType.guildText,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
  );
}
