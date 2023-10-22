import 'package:mineral/api/server/contracts/channels/guild_channel_contracts.dart';
import 'package:mineral/api/server/contracts/guild_member_contracts.dart';
import 'package:mineral/api/server/contracts/guild_message_mention_contract.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';

final class GuildMessageMention implements GuildMessageMentionContract {
  @override
  List<GuildChannelContract> channels = [];

  @override
  List<RoleContract> roles = [];

  @override
  List<GuildMemberContract> users = [];
}