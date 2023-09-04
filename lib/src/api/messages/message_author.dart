import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_ioc/ioc.dart';

class MessageAuthor {
  final Snowflake _guildId;
  final User _user;

  MessageAuthor(this._guildId, this._user);

  /// Get guild [Guild] of this
  Guild get _guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  /// Get user [User] of this
  User get user => _user;

  /// Get member [GuildMember] of this
  GuildMember? get member => _guild.members.cache.get(_user.id);
}