import 'package:mineral/api/common/contracts/application_contract.dart';
import 'package:mineral/api/common/contracts/user_contract.dart';
import 'package:mineral/api/private/caches/private_channel_cache.dart';
import 'package:mineral/api/server/caches/guild_cache.dart';

abstract interface class ClientContract {
  abstract final GuildCache guilds;
  abstract final UserContract user;
  abstract final int version;
  abstract final String sessionType;
  abstract final String sessionId;
  abstract final String resumeGatewayUrl;
  abstract final ApplicationContract application;
  abstract final PrivateChannelCache privateChannels;
}