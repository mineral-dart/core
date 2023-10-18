import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/contracts/channel_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';

final class GuildRolesCache implements CacheContract<RoleContract> {
  final GuildContract _guild;

  GuildRolesCache(this._guild);

  @override
  final Collection<Snowflake, RoleContract> cache = Collection();

  @override
  Future<RoleContract> resolve(Snowflake id) async {
    // todo implement request
    return cache.getOrFail(id);
  }
}