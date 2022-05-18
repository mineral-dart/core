import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/guild.dart';
import 'package:mineral/src/api/guild_member.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/user.dart';
import 'package:mineral/src/constants.dart';
import 'package:mineral/src/collection.dart';

class MemberManager implements CacheManager<GuildMember> {
  @override
  Collection<Snowflake, GuildMember> cache = Collection();

  @override
  Snowflake guildId;

  @override
  late Guild guild;

  MemberManager({ required this.guildId });

  @override
  Future<Collection<Snowflake, GuildMember>> sync () async {
    Http http = ioc.singleton('Mineral/Core/Http');
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
