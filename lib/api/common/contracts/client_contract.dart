import 'package:mineral/api/common/contracts/user_contract.dart';
import 'package:mineral/api/private/caches/private_channel_cache.dart';
import 'package:mineral/api/server/caches/guild_cache.dart';

abstract interface class ClientContract {
  abstract final GuildCache guilds;
  abstract final UserContract user;

  abstract final PrivateChannelCache privateChannels;
}