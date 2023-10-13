import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_message_contracts.dart';

final class GuildMessageCache implements CacheContract<GuildMessageContract> {
  @override
  final Collection<Snowflake, GuildMessageContract> cache = Collection();

  @override
  Future<GuildMessageContract> resolve(Snowflake id) async {
    return cache.getOrFail(id);
  }
}