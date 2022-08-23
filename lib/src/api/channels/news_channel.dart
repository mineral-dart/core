import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class NewsChannel extends TextChannel {
  NewsChannel(
    super.description,
    super.lastPinTime,
    super.rateLimit,
    super.threads,
    super.nsfw,
    super.webhooks,
    super.messages,
    super.lastMessageId,
    super.guildId,
    super.parentId,
    super.label,
    super.type,
    super.position,
    super.flags,
    super.permissions,
    super.id
  );

  factory NewsChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return NewsChannel(
      payload['topic'],
      payload['last_pin_timestamp'],
      payload['rate_limit_per_user'],
      ThreadManager(payload['guild_id']) ,
      payload['nsfw'] ?? false,
      WebhookManager(payload['guild_id'], payload['id']),
      MessageManager(),
      payload['last_message_id'],
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
