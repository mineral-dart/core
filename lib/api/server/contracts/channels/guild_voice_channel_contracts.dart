import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/guild_voice_channel_builder.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';

abstract interface class GuildVoiceChannelContract implements GuildChannelContract {
  abstract final int bitrate;
  abstract final int userLimit;
  abstract final Snowflake? parentId;

  Future<void> update (GuildVoiceChannelBuilder builder, { String? reason });
  Future<void> setParent(Snowflake parentId, { String? reason });
  Future<void> setBitrate(int bitrate, { String? reason });
  Future<void> setUserLimit(int limit, { String? reason });
}