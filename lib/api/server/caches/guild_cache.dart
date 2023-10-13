import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';

final class GuildCache implements CacheContract<GuildContract> {
  @override
  final Collection<Snowflake, GuildContract> cache = Collection();

  @override
  Future<GuildContract> resolve(Snowflake id) async {
    return cache.getOrFail(id);
  }
}