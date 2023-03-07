import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class UserManager extends CacheManager<User> {
  Future<User> resolve (Snowflake id) async {
    if (cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: '/users/$id')
      .build();

    if (response.statusCode == 200) {
      User user = User.from(jsonDecode(response.body));
      cache.putIfAbsent(user.id, () => user);

      return user;
    }

    throw ApiException('Unable to fetch channel with id #$id');
  }
}
