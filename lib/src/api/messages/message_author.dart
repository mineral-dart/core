import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_ioc/ioc.dart';

class MessageAuthor {
  final Snowflake _guildId;
  final Snowflake _userId;

  MessageAuthor(this._guildId, this._userId);

  Guild get _guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  User? get user => _guild.members.cache.get(_userId)?.user;
  
  GuildMember? get member => _guild.members.cache.get(_userId);
}