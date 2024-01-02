import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/guild.dart';

final class GuildTextChannel implements GuildChannel {
  @override
  final String id;

  @override
  final String name;

  @override
  final int position;

  @override
  final String guildId;

  @override
  late final Guild guild;

  final String? description;

  GuildTextChannel({
    required this.id,
    required this.name,
    required this.position,
    required this.guildId,
    required this.description,
  });

  factory GuildTextChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildTextChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      guildId: guildId,
      description: json['description'],
    );
  }
}
