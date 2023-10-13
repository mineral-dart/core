import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/api/server/contracts/guild_member_contracts.dart';

final class GuildMemberCache implements CacheContract<GuildMemberContract> {
  final GuildContract _guild;

  GuildMemberCache(this._guild);

  @override
  final Collection<Snowflake, GuildMemberContract> cache = Collection();

  @override
  Future<GuildMemberContract> resolve(Snowflake id) async {
    // todo implement request
    return cache.getOrFail(id);
  }
}