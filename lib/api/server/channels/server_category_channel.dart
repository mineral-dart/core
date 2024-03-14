import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerCategoryChannel extends ServerChannel {
  ServerCategoryChannel({
    required Snowflake id,
    required String name,
    required int position,
  }): super(id, ChannelType.guildCategory, name, position);

  factory ServerCategoryChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return ServerCategoryChannel(
      id: Snowflake(json['id']),
      name: json['name'],
      position: json['position'],
    );
  }
}
