import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/contracts/channel_contract.dart';
import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_message_contracts.dart';

abstract interface class GuildTextChannelContract implements GuildChannelContract {
  abstract final bool isNsfw;
  abstract final int rateLimitPerUser;
  abstract final Snowflake? lastMessageId;
  abstract final String? lastPinTimestamp;
  abstract final CacheContract<dynamic> webhooks;
  abstract final CacheContract<GuildMessageContract> messages;
  abstract final Snowflake? parentId;

  Future<void> send();
  Future<void> setRateLimitPerUser(int rateLimitPerUser, { String? reason });
  Future<void> setNsfw(bool isNsfw, { String? reason });
}