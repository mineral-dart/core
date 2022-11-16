import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class UserManager extends CacheManager<User> {
  @override
  Map<Snowflake, User> cache = {};

  Future<Map<Snowflake, User>> sync() {
    throw UnimplementedError();
  }
}
