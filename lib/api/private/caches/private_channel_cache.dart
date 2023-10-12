import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/contracts/private_channel_contract.dart';

final class PrivateChannelCache implements CacheContract<PrivateChannelContract> {
  @override
  final Collection<Snowflake, PrivateChannelContract> cache = Collection();

  @override
  Future<PrivateChannelContract> resolve(Snowflake id) async {
    return cache.getOrFail(id);
  }
}