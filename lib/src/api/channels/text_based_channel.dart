import 'package:mineral/core/api.dart';
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

  TextBasedChannel(this._nsfw,
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
      super.id);

  /// Is channel allow nsfw
  bool get isNsfw => _nsfw;

  /// Access to [WebhookManager]
  WebhookManager get webhooks => _webhooks;

  /// Allow or disallow nsfw of this
  Future<void> setNsfw(bool value) async {
    await update(ChannelBuilder({ 'nsfw': value}));
  }

  // bulk deletes messages in this channel
  Future<void> bulkDelete(int number) async {
    final int max_messages = 200;
    final int min_messages = 2;
    
    if (number >= max_messages || number <= min_messages) return ioc.use<MineralCli>().console.error('Provided too few or too many messages to delete. Must provide at least $min_messages and at most $max_messages messages to delete. Action canceled');

    Map<Snowflake, Message> messagesFetch = await messages.fetch();
    List<Snowflake> msg = [];
    int i = 1;

    // check if the cache message is empty

    // add messages id to msg Array
    for (Message message in messagesFetch.values) {
      if (i <= number) {
        msg.add(message.id);
        i++;
      }
    }

    // send the request to discord API
    await ioc.use<HttpService>().post(
        url: "/channels/${id}/messages/bulk-delete",
        payload: {
          'messages': msg
        }
    );
  }
}
