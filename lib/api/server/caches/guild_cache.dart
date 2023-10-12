import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_message_contract.dart';

final class GuildCache implements CacheContract<dynamic> {
  @override
  final Collection<Snowflake, dynamic> cache = Collection();

  @override
  Future<dynamic> resolve(Snowflake id) async {
    return cache.getOrFail(id);
  }
}