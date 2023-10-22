import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_member_contracts.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';

abstract interface class GuildMessageMentionContract {
  abstract final List<GuildChannelContract> channels;
  abstract final List<RoleContract> roles;
  abstract final List<GuildMemberContract> users;
}