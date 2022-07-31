import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class NewsChannel extends TextBasedChannel {
  NewsChannel(
    super._id,
    super._type,
    super._position,
    super._label,
    super._applicationId,
    super._flags,
    super._webhooks,
    super.permissionOverwrites,
    super._guild,
    super.description,
    super.nsfw,
    super.lastMessageId,
    super.lastPinTimestamp,
    super._messages,
    super._threads,
  );

  factory NewsChannel.from(Guild? guild, dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for(dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    NewsChannel channel =  NewsChannel(
      payload['id'],
      ChannelType.guildNews,
      payload['position'],
      payload['name'],
      payload['application_id'],
      payload['flags'],
      WebhookManager(),
      permissionOverwriteManager,
      guild,
      payload['topic'],
      payload['nsfw'] ?? false,
      payload['last_message_id'],
      payload['last_pin_timestamp'] != null ? DateTime.parse(payload['last_pin_timestamp']) : null,
      MessageManager(),
      ThreadManager(guildId: guild?.id),
    );

    channel.webhooks?.channel = channel;
    channel.threads.channel = channel;

    return channel;
  }
}
