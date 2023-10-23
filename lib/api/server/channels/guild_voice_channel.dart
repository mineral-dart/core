import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/guild_voice_channel_builder.dart';
import 'package:mineral/api/server/contracts/channels/guild_voice_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/services/http/entities/either.dart';
import 'package:mineral/services/http/entities/http_error.dart';

final class GuildVoiceChannel implements GuildVoiceChannelContract {
  @override
  final Snowflake id;

  @override
  final String name;

  @override
  final Snowflake guildId;

  @override
  final int? position;

  @override
  final Snowflake? parentId;

  @override
  final int bitrate;

  @override
  final int userLimit;

  @override
  GuildContract get guild => container.use<Client>('client').guilds.cache.getOrFail(guildId);

  @override
  Future<void> update (GuildVoiceChannelBuilder builder, { String? reason }) async {
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
  Future<void> delete({ String? reason }) async {}

  @override
  Future<void> setParent(Snowflake parentId, { String? reason }) async {
    GuildVoiceChannelBuilder builder = GuildVoiceChannelBuilder();
    return update(builder.setParent(parentId), reason: reason);
  }

  @override
  Future<void> setPosition(int position, { String? reason }) async {
    GuildVoiceChannelBuilder builder = GuildVoiceChannelBuilder();
    return update(builder.setPosition(position), reason: reason);
  }

  @override
  Future<void> setName(String name, { String? reason }) async {
    GuildVoiceChannelBuilder builder = GuildVoiceChannelBuilder();
    return update(builder.setName(name), reason: reason);
  }

  GuildVoiceChannel._({
    required this.id,
    required this.name,
    required this.guildId,
    required this.position,
    required this.parentId,
    required this.bitrate,
    required this.userLimit
  });

  factory GuildVoiceChannel.fromWss(final payload, final GuildContract guild) {
    return GuildVoiceChannel._(
      id: Snowflake(payload['id']),
      name: payload['name'],
      guildId: guild.id,
      position: payload['position'],
      parentId: payload['parent_id'] != null
          ? Snowflake(payload['parent_id'])
          : null,
      bitrate: payload['bitrate'],
      userLimit: payload['user_limit']
    );
  }
}