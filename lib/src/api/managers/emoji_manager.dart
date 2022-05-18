import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/constants.dart';
import 'package:mineral/src/collection.dart';

class EmojiManager implements CacheManager<Emoji> {
  @override
  Collection<Snowflake, Emoji> cache = Collection();
}
