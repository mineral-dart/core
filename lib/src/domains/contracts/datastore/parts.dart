import 'package:mineral/api.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/server/channels/thread_channel.dart';

abstract interface class DataStorePart {}

abstract interface class ChannelPartContract implements DataStorePart {
  Future<Map<Snowflake, T>> fetch<T extends Channel>(String serverId, bool force);

  Future<T?> get<T extends Channel>(String id, bool force);

  Future<ThreadChannel?> getThread(Snowflake id);

  Future<T?> createServerChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason});

  Future<PrivateChannel?> createPrivateChannel(
      {required Snowflake id, required Snowflake recipientId});

  Future<T?> updateChannel<T extends Channel>(
      {required Snowflake id,
      required Map<String, dynamic> payload,
      required String? reason});

  Future<void> deleteChannel(Snowflake id, String? reason);

  Future<T> createMessage<T extends Message>(
      Snowflake? guildId,
      Snowflake channelId,
      String? content,
      List<MessageEmbed>? embeds,
      Poll? poll,
      List<MessageComponent>? components);

  Future<T?> serializeChannelResponse<T extends Channel>(Response response);
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
  Future<Member> get(String serverId, String memberId, bool force);

  Future<List<Member>> getMembers(Snowflake guildId, {bool force = false});

  Future<Member> updateMember(
      {required Snowflake serverId,
      required Snowflake memberId,
      required Map<String, dynamic> payload,
      required String? reason});

  Future<void> banMember(
      {required Snowflake serverId,
      required Duration? deleteSince,
      required Snowflake memberId,
      String? reason});

  Future<void> kickMember(
      {required Snowflake serverId,
      required Snowflake memberId,
      String? reason});
}

abstract interface class MessagePartContract implements DataStorePart {
  Future<ServerMessage> getServerMessage(
      {required Snowflake messageId, required Snowflake channelId});

  Future<PrivateMessage> getPrivateMessage(
      {required Snowflake messageId, required Snowflake channelId});
}

abstract interface class RolePartContract implements DataStorePart {
  Future<Map<Snowflake, Role>> fetch(String serverId, bool force);
  Future<Role?> get(String serverId, String id, bool force);

  Future<void> addRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason});

  Future<void> removeRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason});

  Future<void> syncRoles(
      {required Snowflake memberId,
      required Snowflake serverId,
      required List<Snowflake> roleIds,
      required String? reason});

  Future<Role?> updateRole(
      {required Snowflake id,
      required Snowflake serverId,
      required Map<String, dynamic> payload,
      required String? reason});

  Future<void> deleteRole(
      {required Snowflake id,
      required Snowflake guildId,
      required String? reason});
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

  Future<Server> updateServer(
      Snowflake id, Map<String, dynamic> payload, String? reason);

  Future<List<T>> getChannels<T extends ServerChannel>(Snowflake id);

  Future<Role> getRole(Snowflake serverId, Snowflake roleId);

  Future<List<Role>> getRoles(Snowflake guildId, {bool force = false});
}

abstract interface class StickerPartContract implements DataStorePart {
  Future<Map<Snowflake, Sticker>> fetch(String serverId, bool force);
  Future<Sticker?> get(String serverId, String id, bool force);
}

abstract interface class UserPartContract implements DataStorePart {
  Future<User> getUser(Snowflake userId);
}

abstract interface class EmojiPartContract implements DataStorePart {
  Future<Map<Snowflake, Emoji>> fetch(String serverId, bool force);
  Future<Emoji?> get(String serverId, String id, bool force);
}
