import 'package:mineral/src/api/guild_member.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/constants.dart';
import 'package:mineral/src/collection.dart';

class MemberManager implements CacheManager<GuildMember> {
  @override
  Collection<Snowflake, GuildMember> cache = Collection();
}
