import 'package:mineral/api/common/contracts/application_contract.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/contracts/user_contract.dart';
import 'package:mineral/api/private/caches/private_channel_cache.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/fold/injectable.dart';

abstract interface class ClientContract extends Injectable  {
  abstract final CacheContract<GuildContract> guilds;
  abstract final UserContract user;
  abstract final int version;
  abstract final String sessionType;
  abstract final String sessionId;
  abstract final String resumeGatewayUrl;
  abstract final ApplicationContract application;
  abstract final PrivateChannelCache privateChannels;
}