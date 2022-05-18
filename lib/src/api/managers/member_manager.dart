import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class MemberManager implements CacheManager<GuildMember> {
  @override
  Collection<Snowflake, GuildMember> cache = Collection();

  Snowflake guildId;
  late Guild guild;

  MemberManager({ required this.guildId });

  @override
  Future<Collection<Snowflake, GuildMember>> sync () async {
    Http http = ioc.singleton(Service.http);
    cache.clear();

    Response response = await http.get("/guilds/$guildId/members");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      GuildMember guildMember = GuildMember.from(
        user: User.from(element['user']),
        roles: guild.roles,
        guildId: guild.id
      );

      cache.putIfAbsent(guildMember.user.id, () => guildMember);
    }

    return cache;
  }
}
