import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/guild.dart';

final class GuildCategoryChannel implements GuildChannel {
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

  GuildCategoryChannel({
    required this.id,
    required this.name,
    required this.position,
    required this.guildId,
  });

  factory GuildCategoryChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildCategoryChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      guildId: guildId,
    );
  }
}
