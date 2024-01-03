import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/guild.dart';

final class GuildCategoryChannel extends GuildChannel {
  @override
  final int position;

  @override
  late final Guild guild;

  GuildCategoryChannel({
    required String id,
    required String name,
    required this.position,
  }): super(id, name);

  factory GuildCategoryChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildCategoryChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
    );
  }
}
