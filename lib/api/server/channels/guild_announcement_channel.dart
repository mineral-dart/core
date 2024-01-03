import 'package:mineral/api/server/channels/guild_channel.dart';

final class GuildAnnouncementChannel extends GuildChannel {
  final String? description;

  GuildAnnouncementChannel({
    required String id,
    required String name,
    required int position,
    required this.description,
  }): super(id, name, position);

  factory GuildAnnouncementChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildAnnouncementChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      description: json['description'],
    );
  }
}
