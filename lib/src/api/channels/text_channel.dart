import 'package:mineral/src/api/channels/text_based_channel.dart';
import 'package:mineral/src/constants.dart';

class TextChannel extends TextBasedChannel {
  TextChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required Snowflake? description,
    required bool nsfw,
    required Snowflake? lastMessageId,
    required DateTime? lastPin,
  }) : super(
    id: id,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
    description: description,
    nsfw: nsfw,
    lastMessageId: lastMessageId,
    lastPin: lastPin,
  );
}
