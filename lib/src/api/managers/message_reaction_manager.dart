import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/builders/emoji_builder.dart';
import 'package:mineral/src/api/guilds/guild_member_reaction.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/managers/guild_member_reaction_manager.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_ioc/ioc.dart';

class MessageReactionManager<C extends PartialChannel, T extends PartialMessage> extends CacheManager  {
  Map<Snowflake, GuildMemberReactionManager> users = {};

  final C _channel;
  late final T message;

  MessageReactionManager(this._channel);

  Future<void> add (EmojiBuilder emojiBuilder) async {
    MineralClient client = ioc.use<MineralClient>();

    String _emoji = emojiBuilder.emoji is Emoji
      ? '${emojiBuilder.emoji.label}:${emojiBuilder.emoji.id}'
      : emojiBuilder.emoji.label;

    Response response = await ioc.use<HttpService>().put(url: '/channels/${_channel.id}/messages/${message.id}/reactions/$_emoji/@me')
      .build();

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
    Response response = await ioc.use<HttpService>().destroy(url: '/channels/${message.channel.id}/messages/${message.id}/reactions');
    if (response.statusCode == 200) {
      cache.clear();
    }
  }
}
