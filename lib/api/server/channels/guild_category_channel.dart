import 'package:mineral/api/server/channels/guild_channel.dart';

final class GuildCategoryChannel extends GuildChannel {
  GuildCategoryChannel({
    required String id,
    required String name,
    required int position,
  }): super(id, name, position);

  factory GuildCategoryChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildCategoryChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
    );
  }
}
