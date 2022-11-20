import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class CategoryChannel extends GuildChannel {
  CategoryChannel(super.guildId, super.parentId, super.label, super.type, super.position, super.flags, super.permissions, super.id);

  /// Get children of this
  Map<Snowflake, GuildChannel> get children => guild.channels.cache.where((element) => element.parent?.id == id);

  Future<GuildChannel> create (ChannelBuilder channel) async {
    return super.guild.channels.create(channel) as GuildChannel;
  }

  factory CategoryChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return CategoryChannel(
      payload['guild_id'],
      payload['parent_id'],
      payload['name'],
      payload['type'],
      payload['position'],
      payload['flags'],
      permissionOverwriteManager,
      payload['id']
    );
  }
}
