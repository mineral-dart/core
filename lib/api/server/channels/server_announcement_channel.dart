import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerAnnouncementChannel extends ServerChannel {
  final String? description;

  ServerAnnouncementChannel({
    required Snowflake id,
    required String name,
    required int position,
    required this.description,
  }): super(id, ChannelType.guildAnnouncement, name, position);

  factory ServerAnnouncementChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return ServerAnnouncementChannel(
      id: Snowflake(json['id']),
      name: json['name'],
      position: json['position'],
      description: json['description'],
    );
  }
}
