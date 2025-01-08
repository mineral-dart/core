import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/voice_state.dart';

abstract interface class DataStorePart {}

abstract interface class ChannelPartContract implements DataStorePart {
  Future<Map<Snowflake, T>> fetch<T extends Channel>(String serverId, bool force);

  Future<T?> get<T extends Channel>(String id, bool force);

  Future<T> create<T extends Channel>(String? serverId, ChannelBuilderContract builder,
      {String? reason});

  Future<PrivateChannel?> createPrivateChannel(String id, String recipientId);

  Future<T?> update<T extends Channel>(String id, ChannelBuilderContract builder,
      {String? serverId, String? reason});

  Future<void> delete(String id, String? reason);
}

abstract interface class InteractionPartContract implements DataStorePart {
  Future<void> replyInteraction(Snowflake id, String token, Map<String, dynamic> raw);

  Future<void> editInteraction(Snowflake botId, String token, Map<String, dynamic> raw);

  Future<void> deleteInteraction(Snowflake botId, String token);

  Future<void> noReplyInteraction(Snowflake id, String token);

  Future<void> followUpInteraction(Snowflake botId, String token, Map<String, dynamic> raw);

  Future<void> editFollowUpInteraction(
      Snowflake botId, String token, Snowflake messageId, Map<String, dynamic> raw);

  Future<void> deleteFollowUpInteraction(Snowflake botId, String token, Snowflake messageId);

  Future<void> waitInteraction(Snowflake id, String token);

  Future<void> editWaitInteraction(
      Snowflake botId, String token, Snowflake messageId, Map<String, dynamic> raw);

  Future<void> deleteWaitInteraction(Snowflake botId, String token, Snowflake messageId);

  Future<void> sendDialog(Snowflake id, String token, DialogBuilder dialog);
}

abstract interface class MemberPartContract implements DataStorePart {
  Future<Map<Snowflake, Member>> fetch(String serverId, bool force);

  Future<Member?> get(String serverId, String id, bool force);

  Future<Member> update(
      {required String serverId,
      required String memberId,
      required Map<String, dynamic> payload,
      String? reason});

  Future<void> ban(
      {required String serverId,
      required Duration? deleteSince,
      required String memberId,
      String? reason});

  Future<void> kick(
      {required String serverId, required String memberId, String? reason});

  Future<VoiceState?> getVoiceState(String serverId, String userId, bool force);
}

abstract interface class MessagePartContract implements DataStorePart {
  Future<T?> get<T extends BaseMessage>(String channelId, String id, bool force);

  Future<T> update<T extends Message>({
    required String id,
    required String channelId,
    String? content,
    List<MessageEmbed>? embeds,
    List<MessageComponent>? components,
  });

  Future<void> pin(Snowflake channelId, Snowflake id);

  Future<void> unpin(Snowflake channelId, Snowflake id);

  Future<void> crosspost(Snowflake channelId, Snowflake id);

  Future<void> delete(Snowflake channelId, Snowflake id);

  Future<T> send<T extends Message>(String? guildId, String channelId, String? content,
      List<MessageEmbed>? embeds, Poll? poll, List<MessageComponent>? components);

  Future<R> reply<T extends Channel, R extends Message>(
      {required Snowflake id,
      required Snowflake channelId,
      String? content,
      List<MessageEmbed>? embeds,
      List<MessageComponent>? components});
}

abstract interface class RolePartContract implements DataStorePart {
  Future<Map<Snowflake, Role>> fetch(String serverId, bool force);

  Future<Role?> get(String serverId, String id, bool force);

  Future<Role> create(String serverId, String name, List<Permission> permissions, Color color,
      bool hoist, bool mentionable, String? reason);

  Future<void> add(
      {required String memberId,
      required String serverId,
      required String roleId,
      required String? reason});

  Future<void> remove(
      {required String memberId,
      required String serverId,
      required String roleId,
      required String? reason});

  Future<void> sync(
      {required String memberId,
      required String serverId,
      required List<String> roleIds,
      required String? reason});

  Future<Role?> update(
      {required String id,
      required String serverId,
      required Map<String, dynamic> payload,
      required String? reason});

  Future<void> delete(
      {required String id, required String guildId, required String? reason});
}

abstract interface class ServerMessagePartContract implements DataStorePart {
  Future<ServerMessage> update({
    required Snowflake id,
    required Snowflake channelId,
    required Snowflake serverId,
    String? content,
    List<MessageEmbed>? embeds,
    List<MessageComponent>? components,
  });

  Future<ServerMessage> reply(
      {required Snowflake id,
      required Snowflake channelId,
      required Snowflake serverId,
      String? content,
      List<MessageEmbed>? embeds,
      List<MessageComponent>? components});

  Future<void> pin({required Snowflake id, required Snowflake channelId});

  Future<void> unpin({required Snowflake id, required Snowflake channelId});

  Future<void> crosspost({required Snowflake id, required Snowflake channelId});

  Future<void> delete({required Snowflake id, required Snowflake channelId});
}

abstract interface class ServerPartContract implements DataStorePart {
  Future<Server> get(String id, bool force);

  Future<Server> update(String id, Map<String, dynamic> payload, String? reason);

  Future<void> delete(String id, String? reason);
}

abstract interface class StickerPartContract implements DataStorePart {
  Future<Map<Snowflake, Sticker>> fetch(String serverId, bool force);

  Future<Sticker?> get(String serverId, String id, bool force);

  Future<void> delete(String serverId, String stickerId);
}

abstract interface class UserPartContract implements DataStorePart {
  Future<User?> get(String id, bool force);
}

abstract interface class EmojiPartContract implements DataStorePart {
  Future<Map<Snowflake, Emoji>> fetch(String serverId, bool force);

  Future<Emoji?> get(String serverId, String id, bool force);

  Future<Emoji> create(String serverId, String name, Image image, List<String> roles,
      {String? reason});

  Future<Emoji?> update(
      {required String id,
      required String serverId,
      required Map<String, dynamic> payload,
      required String? reason});

  Future<void> delete(String serverId, String emojiId, {String? reason});
}
