import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/forum_discussion_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class ForumChannel extends GuildChannel {
  final ForumDiscussionManager _discussions;

  ForumChannel(
    super.guildId,
    super.parentId,
    super.label,
    super.type,
    super.position,
    super.flags,
    super.permissions,
    super.id,
    this._discussions,
  );

  ForumDiscussionManager get discussions => _discussions;

  factory ForumChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return ForumChannel(
      payload['guild_id'],
      payload['parent_id'],
      payload['name'],
      payload['type'],
      payload['position'],
      payload['flags'],
      permissionOverwriteManager,
      payload['id'],
      ForumDiscussionManager(payload['id']),
    );
  }
}
