import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/channels/guild_voice_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/fold/container.dart';

final class GuildVoiceChannel implements GuildVoiceChannelContract {
  @override
  final Snowflake id;

  @override
  final String name;

  @override
  final Snowflake guildId;

  @override
  final String? topic;

  @override
  final int? position;

  @override
  final Snowflake? parentId;

  @override
  final int bitrate;

  @override
  final int userLimit;

  GuildVoiceChannel._({
    required this.id,
    required this.name,
    required this.guildId,
    required this.topic,
    required this.position,
    required this.parentId,
    required this.bitrate,
    required this.userLimit
  });

  factory GuildVoiceChannel.fromWss(final payload) {
    return GuildVoiceChannel._(
      id: payload['id'].toString().toSnowflake(),
      name: payload['name'],
      guildId: payload['guild_id'].toString().toSnowflake(),
      topic: payload['topic'],
      position: payload['position'],
      parentId: payload['parent_id'].toString().toSnowflake(),
      bitrate: payload['bitrate'],
      userLimit: payload['user_limit']
    );
  }

  @override
  GuildContract get guild => container.use<Client>('client').guilds.cache.getOrFail(guildId);

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
}