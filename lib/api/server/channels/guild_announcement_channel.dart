import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/caches/guild_message_cache.dart';
import 'package:mineral/api/server/caches/guild_webhook_cache.dart';
import 'package:mineral/api/server/contracts/channels/guild_announcement_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/fold/container.dart';

final class GuildAnnouncementChannel implements GuildAnnouncementChannelContract {
  @override
  final Snowflake id;

  @override
  final String name;

  @override
  final Snowflake guildId;

  @override
  final String? topic;

  @override
  final bool isNsfw;

  @override
  final int rateLimitPerUser;

  @override
  final Snowflake? lastMessageId;

  @override
  final String? lastPinTimestamp;

  @override
  final int? position;

  @override
  final Snowflake? parentId;

  @override
  final GuildWebhookCache webhooks = GuildWebhookCache();

  @override
  final GuildMessageCache messages = GuildMessageCache();

  @override
  GuildContract get guild => container.use<Client>('client').guilds.cache.getOrFail(guildId);

  GuildAnnouncementChannel._({
    required this.id,
    required this.name,
    required this.guildId,
    required this.topic,
    required this.isNsfw,
    required this.rateLimitPerUser,
    required this.lastMessageId,
    required this.lastPinTimestamp,
    required this.position,
    required this.parentId,
  });

  factory GuildAnnouncementChannel.fromWss(final payload) {
    return GuildAnnouncementChannel._(
      id: Snowflake(payload['id']),
      name: payload['name'],
      guildId: Snowflake(payload['guild_id']),
      topic: payload['topic'],
      isNsfw: payload['nsfw'] ?? false,
      rateLimitPerUser: payload['rate_limit_per_user'],
      lastMessageId: payload['last_message_id'] != null
          ? Snowflake(payload['last_message_id'])
          : null,
      lastPinTimestamp: payload['last_pin_timestamp'],
      position: payload['position'],
      parentId: payload['parent_id'] != null
          ? Snowflake(payload['parent_id'])
          : null
    );
  }

  @override
  Future<void> send() async {}

  @override
  Future<void> delete({ String? reason }) async {}

  @override
  Future<void> setParent(Snowflake parentId, { String? reason }) async {}

  @override
  Future<void> setPosition(int position, { String? reason }) async {}

  @override
  Future<void> setTopic(String topic, { String? reason }) async {}

  @override
  Future<void> setName(String name, { String? reason }) async {}

  @override
  Future<void> setNsfw(bool isNsfw, { String? reason }) async {}

  @override
  Future<void> setRateLimitPerUser(int rateLimitPerUser, { String? reason }) async {}
}