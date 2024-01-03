import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/guild.dart';

final class GuildTextChannel extends GuildChannel {
  @override
  final int position;

  @override
  late final Guild guild;

  final String? description;

  GuildTextChannel({
    required String id,
    required String name,
    required this.position,
    required this.description,
  }): super(id, name);

  factory GuildTextChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildTextChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      description: json['topic'],
    );
  }
}
