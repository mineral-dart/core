import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/caches/guild_message_cache.dart';
import 'package:mineral/api/server/caches/guild_webhook_cache.dart';
import 'package:mineral/api/server/contracts/guild_text_channel_contracts.dart';

final class GuildTextChannel implements GuildTextChannelContract {
  @override
  final Snowflake id;

  @override
  final String name;

  @override
  final int guildId;

  @override
  final String topic;

  @override
  final bool isNsfw;

  @override
  final int rateLimitPerUser;

  @override
  final Snowflake? lastMessageId;

  @override
  final int? lastPinTimestamp;

  @override
  final int position;

  @override
  final int? parentId;

  @override
  final GuildWebhookCache webhooks = GuildWebhookCache();

  @override
  final GuildMessageCache messages = GuildMessageCache();

  GuildTextChannel._({
    required this.id,
    required this.name,
    required this.guildId,
    required this.topic,
    required this.isNsfw,
    required this.rateLimitPerUser,
    required this.lastMessageId,
    required this.lastPinTimestamp,
    required this.position,
    required this.parentId
  });

  @override
  Future<void> send() async {}

  @override
  Future<void> delete({ String? reason }) async {}
}