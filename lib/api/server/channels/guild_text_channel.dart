import 'package:mineral/api/server/channels/guild_channel.dart';

final class GuildTextChannel extends GuildChannel {
  final String? description;

  GuildTextChannel({
    required String id,
    required String name,
    required int position,
    required this.description,
  }): super(id, name, position);

  factory GuildTextChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildTextChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      description: json['topic'],
    );
  }
}
