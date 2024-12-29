import 'package:mineral/api.dart';
import 'package:mineral/services.dart';

abstract interface class DataStorePart {}

abstract interface class ChannelPartContract implements DataStorePart {
  Future<Map<Snowflake, T>> fetch<T extends Channel>(String serverId, bool force);

  Future<T?> get<T extends Channel>(String id, bool force);

  Future<T> create<T extends Channel>(String? serverId, ChannelBuilderContract builder,
      {String? reason});

  Future<PrivateChannel?> createPrivateChannel(
      {required Snowflake id, required Snowflake recipientId});

  Future<T?> update<T extends Channel>(Snowflake id, ChannelBuilderContract builder,
      {String? serverId, String? reason});

  Future<void> deleteChannel(Snowflake id, String? reason);

  Future<T> createMessage<T extends Message>(Snowflake? guildId, Snowflake channelId,
      String? content, List<MessageEmbed>? embeds, Poll? poll, List<MessageComponent>? components);

  Future<T?> serializeChannelResponse<T extends Channel>(Response response);
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
      {required Snowflake serverId, required Snowflake memberId, String? reason});
}

abstract interface class MessagePartContract implements DataStorePart {
  Future<T?> get<T extends BaseMessage>(String channelId, String id, bool force);

  Future<T> update<T extends Message>({
    required Snowflake id,
    required Snowflake channelId,
    String? content,
    List<MessageEmbed>? embeds,
    List<MessageComponent>? components,
  });

  Future<void> pin(Snowflake channelId, Snowflake id);

  Future<void> unpin(Snowflake channelId, Snowflake id);

  Future<void> crosspost(Snowflake channelId, Snowflake id);

  Future<void> delete(Snowflake channelId, Snowflake id);

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
      {required Snowflake id, required Snowflake guildId, required String? reason});
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

  Future<Server> updateServer(Snowflake id, Map<String, dynamic> payload, String? reason);

  Future<List<T>> getChannels<T extends ServerChannel>(Snowflake id);

  Future<Role> getRole(Snowflake serverId, Snowflake roleId);

  Future<List<Role>> getRoles(Snowflake guildId, {bool force = false});
}

abstract interface class StickerPartContract implements DataStorePart {
  Future<Map<Snowflake, Sticker>> fetch(String serverId, bool force);

  Future<Sticker?> get(String serverId, String id, bool force);
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
