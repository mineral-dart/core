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

  String channel(Snowflake channelId, {Snowflake? serverId}) =>
      serverId != null ? '${server(serverId)}/channels/$channelId' : 'channel/$channelId';

  String channelPermission(Snowflake channelId, {Snowflake? serverId}) =>
      '${channel(channelId, serverId: serverId)}/permissions';

  String serverRole(Snowflake serverId, Snowflake roleId, {bool ref = false}) =>
      '${server(serverId)}/role/$roleId';

  String member(Snowflake serverId, Snowflake memberId, {bool ref = false}) {
    final key = '${server(serverId)}/members/$memberId';
    return ref ? 'ref:$key' : key;
  }

  String memberAssets(Snowflake serverId, Snowflake memberId, {bool ref = false}) {
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

  String serverEmoji(Snowflake serverId, Snowflake emojiId, {bool ref = false}) {
    final key = '${server(serverId)}/emojis/$emojiId';
    return ref ? 'ref:$key' : key;
  }

  String serverMessage({required Snowflake channelId, required Snowflake messageId}) =>
      '${channel(channelId)}/message-$messageId';

  String privateMessage({required Snowflake channelId, required Snowflake messageId}) =>
      '${channel(channelId)}/message-$messageId';

  String embed(Snowflake messageId, { String? uid }) => 'messages/$messageId/embeds/${uid ?? Uuid().v4()}';

  String poll(Snowflake messageId, { String? uid }) => 'messages/$messageId/polls/${uid ?? Uuid().v4()}';

  String sticker(Snowflake stickerId) => 'stickers/$stickerId';
}
