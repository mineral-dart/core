import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/guild.dart';

final class GuildVoiceChannel extends GuildChannel {
  @override
  final int position;

  @override
  late final Guild guild;

  GuildVoiceChannel({
    required String id,
    required String name,
    required this.position,
  }): super(id, name);

  factory GuildVoiceChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildVoiceChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
    );
  }
}
