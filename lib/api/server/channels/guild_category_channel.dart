import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/guild_category_channel_builder.dart';
import 'package:mineral/api/server/channels/guild_announcement_channel.dart';
import 'package:mineral/api/server/channels/guild_text_channel.dart';
import 'package:mineral/api/server/channels/guild_voice_channel.dart';
import 'package:mineral/api/server/contracts/channels/guild_category_channel_contracts.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/services/http/entities/either.dart';
import 'package:mineral/services/http/entities/http_error.dart';

final class GuildCategoryChannel implements GuildCategoryChannelContracts {
  @override
  final Snowflake id;

  @override
  final Snowflake guildId;

  @override
  final String name;

  @override
  final int? position;

  @override
  GuildContract get guild => container.use<Client>('client').guilds.cache.getOrFail(guildId);

  GuildCategoryChannel._({
    required this.id,
    required this.guildId,
    required this.name,
    required this.position,
  });

  @override
  Future<void> update (GuildCategoryChannelBuilder builder, { String? reason }) async {
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
  Future<void> delete({ String? reason }) async {
    final http = DiscordHttpClient.singleton();

    await http.delete('/channels/${id.value}')
        .build();
  }

  @override
  Future<void> setName(String name, { String? reason }) async {}

  @override
  Future<void> setPosition(int position, { String? reason }) async {}

  @override
  List<GuildChannelContract> get channels {
    return guild.channels.cache.values
      .where((channel) =>
        switch(channel) {
          GuildCategoryChannel() => false,
          GuildTextChannel(parentId: final id) when id == this.id => true,
          GuildVoiceChannel(parentId: final id) when id == this.id => true,
          GuildAnnouncementChannel(parentId: final id) when id == this.id => true,
          _ => false
        })
      .toList();
  }

  factory GuildCategoryChannel.fromWss(final payload, final GuildContract guild) => GuildCategoryChannel._(
    id: Snowflake(payload['id']),
    name: payload['name'],
    position: payload['position'],
    guildId: guild.id,
  );
}