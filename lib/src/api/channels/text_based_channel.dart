import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/builders/channel_builder.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:http/http.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:mineral/core.dart';
import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral/src/api/managers/message_manager.dart';

class TextBasedChannel extends PartialTextChannel {
  final bool _nsfw;
  final WebhookManager _webhooks;

  TextBasedChannel(
    this._nsfw,
    this._webhooks,
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

  /// Is channel allow nsfw
  bool get isNsfw => _nsfw;

  /// Access to [WebhookManager]
  WebhookManager get webhooks => _webhooks;

  /// Allow or disallow nsfw of this
  Future<void> setNsfw(bool value) async {
    await update(ChannelBuilder({ 'nsfw': value}));
  }

  /// Bulk deletes messages in this channel
  Future<void> bulkDelete(int amount) async {
    final int maxMessages = 200;
    final int minMessages = 2;

    if (amount >= maxMessages || amount <= minMessages) {
      return ioc.use<MineralCli>()
        .console.error('Provided too few or too many messages to delete. Must provide at least $minMessages and at most $maxMessages messages to delete. Action canceled');
    }

    Map<Snowflake, Message> fetchedMessages = messages.cache.clone;

    if (fetchedMessages.values.isEmpty || messages.cache.length < amount) {
      fetchedMessages = await messages.fetch();
    }

    await ioc.use<DiscordApiHttpService>()
      .post(url: '/channels/$id/messages/bulk-delete')
      .payload({ 'messages': fetchedMessages.keys.toList() })
      .build();
  }
}
