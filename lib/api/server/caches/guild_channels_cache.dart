import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/contracts/channel_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';

final class GuildChannelsCache implements CacheContract<ChannelContract> {
  final GuildContract _guild;

  GuildChannelsCache(this._guild);

  @override
  final Collection<Snowflake, ChannelContract> cache = Collection();

  @override
  Future<ChannelContract> resolve(Snowflake id) async {
    // todo implement request
    return cache.getOrFail(id);
  }
}