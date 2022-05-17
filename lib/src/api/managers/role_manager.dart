import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/role.dart';
import 'package:mineral/src/constants.dart';
import 'package:mineral/src/collection.dart';

class RoleManager implements CacheManager<Role> {
  @override
  Collection<Snowflake, Role> cache = Collection();
}
