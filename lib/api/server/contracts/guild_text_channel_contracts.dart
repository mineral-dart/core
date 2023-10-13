import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/contracts/channel_contract.dart';
import 'package:mineral/api/server/contracts/guild_message_contracts.dart';

abstract interface class GuildTextChannelContract implements ChannelContract {
  abstract final int guildId;
  abstract final String topic;
  abstract final bool isNsfw;
  abstract final int rateLimitPerUser;
  abstract final Snowflake? lastMessageId;
  abstract final int? lastPinTimestamp;
  abstract final int position;
  abstract final int? parentId;
  abstract final CacheContract<dynamic> webhooks;
  abstract final CacheContract<GuildMessageContract> messages;

  Future<void> send();

  Future<void> delete({ String? reason });
}