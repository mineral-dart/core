import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class RoleManager implements CacheManager<Role> {
  @override
  Collection<Snowflake, Role> cache = Collection();

  Snowflake guildId;
  late Guild guild;

  RoleManager({ required this.guildId });

  @override
  Future<Collection<Snowflake, Role>> sync () async {
    Http http = ioc.singleton(Service.http);
    cache.clear();

    Response response = await http.get("/guilds/$guildId/roles");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      print(element);
      Role role = Role.from(element);
      cache.putIfAbsent(role.id, () => role);
    }

    return cache;
  }
}
