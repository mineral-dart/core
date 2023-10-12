import 'package:mineral/api/common/contracts/application_contract.dart';
import 'package:mineral/api/common/contracts/client_contract.dart';
import 'package:mineral/api/common/contracts/user_contract.dart';
import 'package:mineral/api/private/caches/private_channel_cache.dart';
import 'package:mineral/api/server/caches/guild_cache.dart';

final class Client implements ClientContract {
  @override
  final GuildCache guilds = GuildCache();

  @override
  final PrivateChannelCache privateChannels = PrivateChannelCache();

  @override
  final UserContract user;

  @override
  final int version;

  @override
  final String sessionType;

  @override
  final String sessionId;

  @override
  final String resumeGatewayUrl;

  @override
  final ApplicationContract application;

  Client({
    required this.version,
    required this.user,
    required this.sessionType,
    required this.sessionId,
    required this.resumeGatewayUrl,
    required this.application,
  });
}