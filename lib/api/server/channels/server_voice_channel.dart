import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerVoiceChannel extends ServerChannel {
  ServerVoiceChannel({
    required Snowflake id,
    required String name,
    required int position,
  }): super(id, ChannelType.guildVoice, name, position);

  factory ServerVoiceChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return ServerVoiceChannel(
      id: Snowflake(json['id']),
      name: json['name'],
      position: json['position'],
    );
  }
}
