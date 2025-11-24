import 'package:uuid/uuid.dart';

final class CacheKey {
  String server(Object id) => 'server/$id';

  String serverAssets(Object serverId, {bool isRef = false}) {
    final key = '${server(serverId)}/assets';
    return isRef ? 'ref:$key' : key;
  }

  String serverSettings(String serverId, {bool isRef = false}) {
    final key = '${server(serverId)}/settings';
    return isRef ? 'ref:$key' : key;
  }

  String serverRules(Object serverId, Object ruleId, {bool isRef = false}) {
    final key = '${server(serverId)}/rules/$ruleId';
    return isRef ? 'ref:$key' : key;
  }

  String serverSubscription(String serverId, {bool isRef = false}) {
    final key = '${server(serverId)}/subscriptions';
    return isRef ? 'ref:$key' : key;
  }

  String channel(Object channelId) => 'channels/$channelId';

  String channelPermission(Object channelId, {Object? serverId}) =>
      '${channel(channelId)}/permissions';

  String serverRole(Object serverId, Object roleId) =>
      '${server(serverId)}/roles/$roleId';

  String member(Object serverId, Object memberId, {bool isRef = false}) {
    final key = '${server(serverId)}/members/$memberId';
    return isRef ? 'ref:$key' : key;
  }

  String memberAssets(Object serverId, Object memberId, {bool isRef = false}) {
    final key = '${member(serverId, memberId)}/assets';
    return isRef ? 'ref:$key' : key;
  }

  String user(Object userId, {bool isRef = false}) {
    final key = 'users/$userId';
    return isRef ? 'ref:$key' : key;
  }

  String voiceState(Object serverId, Object userId) =>
      'voice_states/${member(serverId, userId)}';

  String invite(String code) => 'invites/$code';

  String userAssets(Object userId, {bool isRef = false}) {
    final key = '${user(userId)}/assets';
    return isRef ? 'ref:$key' : key;
  }

  String serverEmoji(Object serverId, Object emojiId) =>
      '${server(serverId)}/emojis/$emojiId';

  String message(Object channelId, Object messageId) =>
      '${channel(channelId)}/messages/$messageId';

  String embed(Object messageId, {Object? uid}) =>
      'messages/$messageId/embeds/${uid ?? Uuid().v4()}';

  String poll(Object messageId, {Object? uid}) =>
      'messages/$messageId/polls/${uid ?? Uuid().v4()}';

  String sticker(Object serverId, Object stickerId) =>
      '${server(serverId)}/stickers/$stickerId';

  String thread(Object threadId) => 'threads/$threadId';
}
