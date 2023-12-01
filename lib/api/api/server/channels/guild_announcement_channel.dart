import 'package:mineral/api/api/server/channels/guild_channel.dart';
import 'package:mineral/api/api/server/guild.dart';

final class GuildAnnouncementChannel implements GuildChannel {
  @override
  final String id;

  @override
  final String name;

  @override
  final int position;

  @override
  final String guildId;

  @override
  final Guild guild;

  final String description;

  GuildAnnouncementChannel({
    required this.id,
    required this.name,
    required this.position,
    required this.guildId,
    required this.guild,
    required this.description,
  });
}
