import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/builders/channel_builder.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:http/http.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:mineral/core.dart';
import 'package:mineral_cli/mineral_cli.dart';

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
  Future<void> setNsfw (bool value) async {
    await update(ChannelBuilder({ 'nsfw': value }));
  }

  Future<void> bulkDelete(double number) async {
    if  (number > 200) {
      return ioc.use<MineralCli>().console.error('The number $number is too high, and exceeds the limit of 200 maximum messages');
    }

    final Map<Snowflake, Message> messagesFetch = await messages.fetch();
    List<Snowflake> msg = [];

    int i = 0;
    for (Message message in messagesFetch.values) {
      if(i <= number - 1) {
        msg.add(message.id);
        i++;
      }
    }

    await ioc.use<HttpService>().post(url: "/channels/${id}/messages/bulk-delete", payload: {
      'messages': msg
    });
  }
}
