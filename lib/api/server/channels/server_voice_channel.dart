import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerVoiceChannel extends ServerChannel {
  ServerVoiceChannel({
    required Snowflake id,
    required String name,
    required int position,
    required List<ChannelPermissionOverwrite> permissionOverwrites,
  }): super(id, ChannelType.guildVoice, name, position, permissionOverwrites);
}
