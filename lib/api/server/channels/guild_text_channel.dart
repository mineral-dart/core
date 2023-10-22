import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/guild_text_channel_builder.dart';
import 'package:mineral/api/server/caches/guild_message_cache.dart';
import 'package:mineral/api/server/caches/guild_webhook_cache.dart';
import 'package:mineral/api/server/contracts/channels/guild_text_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/services/http/entities/either.dart';
import 'package:mineral/services/http/entities/http_error.dart';

final class GuildTextChannel implements GuildTextChannelContract {
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

  @override
  Future<void> update (GuildTextChannelBuilder builder, { String? reason }) async {
    final http = DiscordHttpClient.singleton();

    final request = http.patch('/channels/${id.value}')
      .payload(builder.build())
      .build();

    await Either.future(
      future: request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
        => throw ArgumentError(message),
      }
    );
  }

  @override
  Future<void> send() async {}

  @override
  Future<void> delete({ String? reason }) async {
    final http = DiscordHttpClient.singleton();

    final request = http.delete('/channels/${id.value}')
      .build();

    await Either.future(
      future: request,
      onError: (HttpError error) => switch(error) {
        HttpError(message: final message)
          => throw ArgumentError(message),
      }
    );
  }

  @override
  Future<void> setParent(Snowflake parentId, { String? reason }) async {
    GuildTextChannelBuilder builder = GuildTextChannelBuilder();
    return update(builder.setParentId(parentId), reason: reason);
  }

  @override
  Future<void> setPosition(int position, { String? reason }) async {
    GuildTextChannelBuilder builder = GuildTextChannelBuilder();
    return update(builder.setPosition(position), reason: reason);
  }

  @override
  Future<void> setTopic(String topic, { String? reason }) async {
    GuildTextChannelBuilder builder = GuildTextChannelBuilder();
    return update(builder.setTopic(topic), reason: reason);
  }

  @override
  Future<void> setName(String name, { String? reason }) async {
    GuildTextChannelBuilder builder = GuildTextChannelBuilder();
    return update(builder.setName(name), reason: reason);
  }

  @override
  Future<void> setNsfw(bool isNsfw, { String? reason }) async {
    GuildTextChannelBuilder builder = GuildTextChannelBuilder();
    return update(builder.setNsfw(isNsfw), reason: reason);
  }

  @override
  Future<void> setRateLimitPerUser(int rateLimitPerUser, { String? reason }) async {
    GuildTextChannelBuilder builder = GuildTextChannelBuilder();
    return update(builder.setRateLimitPerUser(rateLimitPerUser), reason: reason);
  }

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

  factory GuildTextChannel.fromWss(final payload, final GuildContract guild) {
    return GuildTextChannel._(
      id: Snowflake(payload['id']),
      name: payload['name'],
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
          : null,
      guildId: guild.id,
    );
  }
}