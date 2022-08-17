import 'package:mineral/api.dart';
import 'package:mineral/src/api/guilds/guild_member_reaction.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class GuildMemberReactionManager extends CacheManager<GuildMemberReaction> {
  final Map<Snowflake, GuildMemberReaction> reactions = {};
  final PartialMessage _message;
  final User _user;

  GuildMemberReactionManager(this._message, this._user);

  PartialMessage get message => _message;
  User get user => _user;
}
