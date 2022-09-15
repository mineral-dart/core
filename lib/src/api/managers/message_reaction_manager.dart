import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/guilds/guild_member_reaction.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/managers/guild_member_reaction_manager.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class MessageReactionManager<C extends PartialChannel, T extends PartialMessage> extends CacheManager {
  Map<Snowflake, GuildMemberReactionManager> users = {};

  final C _channel;
  late final T message;

  MessageReactionManager(this._channel);

  Future<void> add (EmojiBuilder emojiBuilder) async {
    Http http = ioc.singleton(Service.http);
    MineralClient client = ioc.singleton(Service.client);

    String _emoji = emojiBuilder.emoji is Emoji
      ? '${emojiBuilder.emoji.label}:${emojiBuilder.emoji.id}'
      : emojiBuilder.emoji.label;

    Response response = await http.put(url: '/channels/${_channel.id}/messages/${message.id}/reactions/$_emoji/@me', payload: {});

    if (response.statusCode == 204) {
      final key = emojiBuilder.emoji.id != '' ? emojiBuilder.emoji.id : emojiBuilder.emoji.label;
      GuildMemberReactionManager? memberCache = users.get(client.user.id);

      if (memberCache == null) {
        final reactionManager = GuildMemberReactionManager(message, client.user);
        reactionManager.reactions.putIfAbsent(key, () => GuildMemberReaction(reactionManager, emojiBuilder.emoji, message, client.user));

        users.putIfAbsent(client.user.id, () => reactionManager);
        memberCache = reactionManager;
      }

      memberCache.reactions.putIfAbsent(key, () => GuildMemberReaction(
          memberCache!,
          emojiBuilder.emoji,
          message,
          client.user
      ));
    }
  }

  Future<void> removeAll () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.destroy(url: '/channels/${message.channel.id}/messages/${message.id}/reactions');
    if (response.statusCode == 200) {
      cache.clear();
    }
  }
}
