import 'package:mineral/api.dart';

class CategoryChannel extends GuildChannel {
  CategoryChannel(super.guildId, super.parentId, super.label, super.type, super.position, super.flags, super.permissions, super.id);

  /// Get children of this
  Map<Snowflake, GuildChannel> get children => guild.channels.cache.where((element) => element.parent?.id == id);
}
