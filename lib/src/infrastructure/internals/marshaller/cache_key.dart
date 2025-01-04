import 'package:uuid/uuid.dart';

final class CacheKey {
  String server(String id) => 'server/$id';

  String serverAssets(String serverId, {bool ref = false}) {
    final key = '${server(serverId)}/assets';
    return ref ? 'ref:$key' : key;
  }

  String serverSettings(String serverId, {bool ref = false}) {
    final key = '${server(serverId)}/settings';
    return ref ? 'ref:$key' : key;
  }

  String serverSubscription(String serverId, {bool ref = false}) {
    final key = '${server(serverId)}/subscriptions';
    return ref ? 'ref:$key' : key;
  }

  String channel(String channelId) => 'channels/$channelId';

  String channelPermission(String channelId, {String? serverId}) =>
      '${channel(channelId)}/permissions';

  String serverRole(String serverId, String roleId) => '${server(serverId)}/roles/$roleId';

  String member(String serverId, String memberId, {bool ref = false}) {
    final key = '${server(serverId)}/members/$memberId';
    return ref ? 'ref:$key' : key;
  }

  String memberAssets(String serverId, String memberId,
      {bool ref = false}) {
    final key = '${member(serverId, memberId)}/assets';
    return ref ? 'ref:$key' : key;
  }

  String user(String userId, {bool ref = false}) {
    final key = 'users/$userId';
    return ref ? 'ref:$key' : key;
  }

  String voiceState(String serverId, String userId) => '${member(serverId, userId)}/voice_states';

  String userAssets(String userId, {bool ref = false}) {
    final key = '${user(userId)}/assets';
    return ref ? 'ref:$key' : key;
  }

  String serverEmoji(String serverId, String emojiId) => '${server(serverId)}/emojis/$emojiId';

  String message(String channelId, String messageId) =>
      '${channel(channelId)}/messages/$messageId';

  String embed(String messageId, {String? uid}) =>
      'messages/$messageId/embeds/${uid ?? Uuid().v4()}';

  String poll(String messageId, {String? uid}) =>
      'messages/$messageId/polls/${uid ?? Uuid().v4()}';

  String sticker(String serverId, String stickerId) =>
      '${server(serverId)}/stickers/$stickerId';

  String thread(String threadId) => 'threads/$threadId';
}
