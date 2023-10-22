import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_message_contracts.dart';
import 'package:mineral/api/server/contracts/guild_message_mention_contract.dart';
import 'package:mineral/api/server/messages/guild_message_mention.dart';

final class GuildMessage implements GuildMessageContract {
  @override
  final Snowflake id;

  @override
  final String content;

  @override
  final Snowflake channelId;

  @override
  final bool isPinned;

  @override
  final bool isTTS;

  @override
  final List<dynamic> embeds;

  @override
  final List<dynamic> attachments;

  @override
  final GuildMessageMentionContract mentions = GuildMessageMention();

  @override
  final List<dynamic> reactions;

  @override
  final int timestamp;

  @override
  final int editedTimestamp;

  @override
  final int flags;

  GuildMessage({
    required this.id,
    required this.content,
    required this.channelId,
    required this.isPinned,
    required this.isTTS,
    required this.embeds,
    required this.attachments,
    required this.reactions,
    required this.timestamp,
    required this.editedTimestamp,
    required this.flags,
  });
}