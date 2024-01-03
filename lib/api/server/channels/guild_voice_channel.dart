import 'package:mineral/api/server/channels/guild_channel.dart';

final class GuildVoiceChannel extends GuildChannel {
  GuildVoiceChannel({
    required String id,
    required String name,
    required int position,
  }): super(id, name, position);

  factory GuildVoiceChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildVoiceChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
    );
  }
}
