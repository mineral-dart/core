import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/contracts/cache_contract.dart';
import 'package:mineral/api/common/contracts/channel_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/emoji_contracts.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';

final class GuildEmojisCache implements CacheContract<EmojiContract> {
  final GuildContract _guild;

  GuildEmojisCache(this._guild);

  @override
  final Collection<Snowflake, EmojiContract> cache = Collection();

  @override
  Future<EmojiContract> resolve(Snowflake id) async {
    // todo implement request
    return cache.getOrFail(id);
  }
}