import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/messages/message_reaction.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class MessageReactionManager<C extends PartialChannel, T extends PartialMessage> extends CacheManager<MessageReaction> {
  final C _channel;
  late final T message;

  MessageReactionManager(this._channel);

  Future<void> add (EmojiBuilder emojiBuilder) async {
    String _emoji = emojiBuilder.emoji is Emoji
      ? '${emojiBuilder.emoji.label}:${emojiBuilder.emoji.id}'
      : emojiBuilder.emoji.label;

    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.put(url: '/channels/${_channel.id}/messages/${message.id}/reactions/$_emoji//@me', payload: {});
    print(response.body);
  }
}
