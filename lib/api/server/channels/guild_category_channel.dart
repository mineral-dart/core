import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/guild_announcement_channel.dart';
import 'package:mineral/api/server/channels/guild_text_channel.dart';
import 'package:mineral/api/server/channels/guild_voice_channel.dart';
import 'package:mineral/api/server/contracts/channels/guild_category_channel_contracts.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/api/server/guild.dart';
import 'package:mineral/internal/fold/container.dart';

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
  final String? topic;

  @override
  GuildContract get guild => container.use<Client>('client').guilds.cache.getOrFail(guildId);

  GuildCategoryChannel._({
    required this.id,
    required this.guildId,
    required this.name,
    required this.position,
    required this.topic,
  });

  @override
  Future<void> delete({String? reason}) async {}

  @override
  Future<void> setName(String name, {String? reason}) async {}

  @override
  Future<void> setParent(Snowflake parentId, {String? reason}) async {}

  @override
  Future<void> setPosition(int position, {String? reason}) async {}

  @override
  Future<void> setTopic(String topic, {String? reason}) async {}

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

  factory GuildCategoryChannel.fromWss(final payload) => GuildCategoryChannel._(
      id: Snowflake(payload['id']),
      name: payload['name'],
      position: payload['position'],
      topic: payload['topic'],
      guildId: Snowflake(payload['guild_id']),
    );
}