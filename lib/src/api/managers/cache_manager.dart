import 'package:mineral/src/api/guild.dart';
import 'package:mineral/src/collection.dart';
import 'package:mineral/src/constants.dart';

abstract class CacheManager<T> {
  Collection<Snowflake, T> cache = Collection();

  Snowflake guildId;
  late Guild guild;

  CacheManager({ required this.guildId });

  Future<Collection<Snowflake, T>> sync () async {
    throw UnimplementedError();
  }
}
