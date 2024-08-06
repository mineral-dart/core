import 'package:mineral/api/common/snowflake.dart';

abstract interface class CacheKeyContract {
  String server(Snowflake id);

  String channel(Snowflake id);

  String serverRole({required Snowflake serverId, required Snowflake roleId});

  String serverMember({required Snowflake serverId, required Snowflake memberId});

  String serverEmoji({required Snowflake serverId, required Snowflake emojiId});

  String serverMessage({required Snowflake channelId, required Snowflake messageId});

  String privateMessage({required Snowflake channelId, required Snowflake messageId});
}

final class CacheKey implements CacheKeyContract {
  @override
  String server(Snowflake id) => 'server-$id';

  @override
  String channel(Snowflake channelId) =>
      'channel-$channelId';

  @override
  String serverRole({required Snowflake serverId, required Snowflake roleId}) =>
      '${server(serverId)}/role-$roleId';

  @override
  String serverMember({required Snowflake serverId, required Snowflake memberId}) =>
      '${server(serverId)}/member-$memberId';

  @override
  String serverEmoji({required Snowflake serverId, required Snowflake emojiId}) =>
      '${server(serverId)}/emoji-$emojiId';

  @override
  String serverMessage({required Snowflake channelId, required Snowflake messageId}) =>
      '${channel(channelId)}/message-$messageId';

  @override
  String privateMessage({required Snowflake channelId, required Snowflake messageId}) =>
      '${channel(channelId)}/message-$messageId';
}
