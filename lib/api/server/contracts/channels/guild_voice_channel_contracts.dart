import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';

abstract interface class GuildVoiceChannelContract implements GuildChannelContract {
  abstract final int bitrate;
  abstract final int userLimit;
  abstract final Snowflake? parentId;
}