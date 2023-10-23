import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/guild_announcement_channel_builder.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_message_contracts.dart';

abstract interface class GuildAnnouncementChannelContract implements GuildChannelContract {
  Future<void> update (GuildAnnouncementChannelBuilder builder, { String? reason });
  abstract final bool isNsfw;
  abstract final int rateLimitPerUser;
  abstract final Snowflake? lastMessageId;
  abstract final String? lastPinTimestamp;
  abstract final CacheContract<dynamic> webhooks;
  abstract final CacheContract<GuildMessageContract> messages;
  abstract final Snowflake? parentId;

  Future<void> send({ List<MessageEmbed>? embeds, String? content, String? tts });
  Future<void> setNsfw(bool isNsfw, { String? reason });
}