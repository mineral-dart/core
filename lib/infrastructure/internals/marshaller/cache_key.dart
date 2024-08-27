import 'package:mineral/api/common/snowflake.dart';
import 'package:uuid/uuid.dart';

final class CacheKey {
  String server(Snowflake id, {bool ref = false}) {
    final key = 'server/$id';
    return ref ? '$key:ref' : key;
  }

  String serverAssets(Snowflake serverId, {bool ref = false}) {
    final key = '${server(serverId)}/assets';
    return ref ? 'ref:$key' : key;
  }

  String serverSettings(Snowflake serverId, {bool ref = false}) {
    final key = '${server(serverId)}/settings';
    return ref ? 'ref:$key' : key;
  }

  String serverSubscription(Snowflake serverId, {bool ref = false}) {
    final key = '${server(serverId)}/subscriptions';
    return ref ? 'ref:$key' : key;
  }

  String channel(Snowflake channelId) => 'channels/$channelId';

  String channelPermission(Snowflake channelId, {Snowflake? serverId}) =>
      '${channel(channelId)}/permissions';

  String serverRole(Snowflake serverId, Snowflake roleId, {bool ref = false}) =>
      '${server(serverId)}/role/$roleId';

  String member(Snowflake serverId, Snowflake memberId, {bool ref = false}) {
    final key = '${server(serverId)}/members/$memberId';
    return ref ? 'ref:$key' : key;
  }

  String memberAssets(Snowflake serverId, Snowflake memberId,
      {bool ref = false}) {
    final key = '${member(serverId, memberId)}/assets';
    return ref ? 'ref:$key' : key;
  }

  String user(Snowflake userId, {bool ref = false}) {
    final key = 'users/$userId';
    return ref ? 'ref:$key' : key;
  }

  String userAssets(Snowflake userId, {bool ref = false}) {
    final key = '${user(userId)}/assets';
    return ref ? 'ref:$key' : key;
  }

  String serverEmoji(Snowflake serverId, Snowflake emojiId,
      {bool ref = false}) {
    final key = '${server(serverId)}/emojis/$emojiId';
    return ref ? 'ref:$key' : key;
  }

  String message(Snowflake channelId, Snowflake messageId) =>
      '${channel(channelId)}/messages/$messageId';

  String embed(Snowflake messageId, {String? uid}) =>
      'messages/$messageId/embeds/${uid ?? Uuid().v4()}';

  String poll(Snowflake messageId, {String? uid}) =>
      'messages/$messageId/polls/${uid ?? Uuid().v4()}';

  String sticker(Snowflake serverId, Snowflake stickerId) =>
      '${server(serverId)}/stickers/$stickerId';

  String thread(Snowflake threadId) => 'threads/$threadId';
}
