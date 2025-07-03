import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/channels/private_thread_channel.dart';
import 'package:mineral/src/api/server/channels/public_thread_channel.dart';
import 'package:mineral/src/api/server/voice_state.dart';

abstract interface class DataStorePart {}

abstract interface class ChannelPartContract implements DataStorePart {
  Future<Map<Snowflake, T>> fetch<T extends Channel>(
      Object serverId, bool force);

  Future<T?> get<T extends Channel>(Object id, bool force);

  Future<T> create<T extends Channel>(
      Object? serverId, ChannelBuilderContract builder,
      {String? reason});

  Future<PrivateChannel?> createPrivateChannel(Object id, String recipientId);

  Future<T?> update<T extends Channel>(
      Object id, ChannelBuilderContract builder,
      {Object? serverId, String? reason});

  Future<void> delete(Object id, String? reason);
}

abstract interface class ThreadPartContract implements DataStorePart {
  Future<ThreadResult> fetchActives(Object serverId);

  Future<Map<Snowflake, PublicThreadChannel>> fetchPublicArchived(
      Object channelId);

  Future<Map<Snowflake, PrivateThreadChannel>> fetchPrivateArchived(
      Object channelId);

  Future<T> createWithoutMessage<T extends ThreadChannel>(
      Object? serverId, Object? channelId, ThreadChannelBuilder builder,
      {String? reason});

  Future<T> createFromMessage<T extends ThreadChannel>(Object? serverId,
      Object? channelId, Object? messageId, ThreadChannelBuilder builder,
      {String? reason});
}

abstract interface class InteractionPartContract implements DataStorePart {
  Future<void> replyInteraction(
      Snowflake id, String token, Map<String, dynamic> raw);

  Future<void> editInteraction(
      Snowflake botId, String token, Map<String, dynamic> raw);

  Future<void> deleteInteraction(Snowflake botId, String token);

  Future<void> noReplyInteraction(Snowflake id, String token);

  Future<void> followUpInteraction(
      Snowflake botId, String token, Map<String, dynamic> raw);

  Future<void> editFollowUpInteraction(Snowflake botId, String token,
      Snowflake messageId, Map<String, dynamic> raw);

  Future<void> deleteFollowUpInteraction(
      Snowflake botId, String token, Snowflake messageId);

  Future<void> waitInteraction(Snowflake id, String token);

  Future<void> editWaitInteraction(Snowflake botId, String token,
      Snowflake messageId, Map<String, dynamic> raw);

  Future<void> deleteWaitInteraction(
      Snowflake botId, String token, Snowflake messageId);

  Future<void> sendDialog(Snowflake id, String token, DialogBuilder dialog);
}

abstract interface class MemberPartContract implements DataStorePart {
  Future<Map<Snowflake, Member>> fetch(Object serverId, bool force);

  Future<Member?> get(Object serverId, Object id, bool force);

  Future<Member> update(
      {required Object serverId,
      required String memberId,
      required Map<String, dynamic> payload,
      String? reason});

  Future<void> ban(
      {required Object serverId,
      required Duration? deleteSince,
      required String memberId,
      String? reason});

  Future<void> kick(
      {required Object serverId, required String memberId, String? reason});

  Future<VoiceState?> getVoiceState(Object serverId, String userId, bool force);
}

abstract interface class MessagePartContract implements DataStorePart {
  Future<Map<Snowflake, T>> fetch<T extends BaseMessage>(Object channelId,
      {Snowflake? around, Snowflake? before, Snowflake? after, int? limit});

  Future<T?> get<T extends BaseMessage>(
      Object channelId, Object id, bool force);

  Future<T> update<T extends Message>({
    required Object id,
    required Object channelId,
    String? content,
    List<MessageEmbed>? embeds,
    List<MessageComponent>? components,
  });

  Future<void> pin(Snowflake channelId, Snowflake id);

  Future<void> unpin(Snowflake channelId, Snowflake id);

  Future<void> crosspost(Snowflake channelId, Snowflake id);

  Future<void> delete(Snowflake channelId, Snowflake id);

  Future<T> send<T extends Message>(
      String? guildId,
      Object channelId,
      String? content,
      List<MessageEmbed>? embeds,
      Poll? poll,
      List<MessageComponent>? components);

  Future<T> sendV2<T extends Message>(
      String? guildId, String channelId, MessageComponentBuilder builder);

  Future<T> sendPoll<T extends Message>(String channelId, Poll poll);

  Future<R> reply<T extends Channel, R extends Message>(
      {required Snowflake id,
      required Snowflake channelId,
      String? content,
      List<MessageEmbed>? embeds,
      List<MessageComponent>? components});

  Future<R> replyV2<T extends Channel, R extends Message>(
      Snowflake id, Snowflake channelId, MessageComponentBuilder builder);
}

abstract interface class RolePartContract implements DataStorePart {
  Future<Map<Snowflake, Role>> fetch(Object serverId, bool force);

  Future<Role?> get(Object serverId, Object id, bool force);

  Future<Role> create(
      Object serverId,
      String name,
      List<Permission> permissions,
      Color color,
      bool hoist,
      bool mentionable,
      String? reason);

  Future<void> add(
      {required String memberId,
      required Object serverId,
      required String roleId,
      required String? reason});

  Future<void> remove(
      {required String memberId,
      required Object serverId,
      required String roleId,
      required String? reason});

  Future<void> sync(
      {required String memberId,
      required Object serverId,
      required List<String> roleIds,
      required String? reason});

  Future<Role?> update(
      {required Object id,
      required Object serverId,
      required Map<String, dynamic> payload,
      required String? reason});

  Future<void> delete(
      {required Object id, required String guildId, required String? reason});
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
  Future<Server> get(Object id, bool force);

  Future<Server> update(
      Object id, Map<String, dynamic> payload, String? reason);

  Future<void> delete(Object id, String? reason);
}

abstract interface class StickerPartContract implements DataStorePart {
  Future<Map<Snowflake, Sticker>> fetch(Object serverId, bool force);

  Future<Sticker?> get(Object serverId, Object id, bool force);

  Future<void> delete(Object serverId, Object stickerId);
}

abstract interface class UserPartContract implements DataStorePart {
  Future<User?> get(Object id, bool force);
}

abstract interface class EmojiPartContract implements DataStorePart {
  Future<Map<Snowflake, Emoji>> fetch(Object serverId, bool force);

  Future<Emoji?> get(Object serverId, Object id, bool force);

  Future<Emoji> create(
      Object serverId, String name, Image image, List<Object> roles,
      {String? reason});

  Future<Emoji?> update(
      {required Object id,
      required Object serverId,
      required Map<String, dynamic> payload,
      required String? reason});

  Future<void> delete(Object serverId, String emojiId, {String? reason});
}

abstract interface class ReactionPartContract implements DataStorePart {
  Future<Map<Snowflake, User>> getUsersForEmoji(
      Object channelId, Object messageId, PartialEmoji emoji);

  Future<void> add(Object channelId, Object messageId, PartialEmoji emoji);

  Future<void> remove(Object channelId, Object messageId, PartialEmoji emoji);

  Future<void> removeAll(Object channelId, Object messageId);

  Future<void> removeForEmoji(
      Object channelId, Object messageId, PartialEmoji emoji);

  Future<void> removeForUser(
      String userId, Object channelId, Object messageId, PartialEmoji emoji);
}

abstract interface class InvitePartContract implements DataStorePart {
  Future<Invite?> get(String code, bool force);

  Future<InviteMetadata?> getExtrasMetadata(String code, bool force);

  // Future<Invite> create(
  //     String code,
  //     String serverId,
  //     String channelId,
  //     String inviterId,
  //     bool isTemporary,
  //     int maxAge, int maxUses);

  Future<void> delete(String code, String? reason);
}
