import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_ioc/ioc.dart';

class WrappedInviter {
  final Snowflake _guildId;
  final Snowflake _userId;

  WrappedInviter(this._guildId, this._userId);

  GuildMember? toMember () => ioc.use<MineralClient>().guilds.cache
    .get(_guildId)?.members.cache
    .get(_userId);

  Future<User> toUser () async => await ioc.use<MineralClient>().users.resolve(_userId);
}