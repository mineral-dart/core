import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildInviteManager extends CacheManager<Invite>  {
  final Snowflake? _guildId;

  GuildInviteManager(this._guildId);

  Future<Map<String, Invite>> sync () async {
    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: '/guilds/$_guildId/invites')
      .build();

    for (dynamic element in jsonDecode(response.body)) {
      Invite invite = Invite.from(element['guild']?['id'], element);
      cache.set(invite.code, invite);
    }

    return cache;
  }

  Future<Invite> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: '/webhooks/$id')
      .build();

    if(response.statusCode == 200) {
      final payload = jsonDecode(response.body);
      final Invite invite = Invite.from(payload['guild']?['id'], payload);

      cache.putIfAbsent(invite.code, () => invite);
      return invite;
    }

    throw ApiException('Unable to fetch invite with code #$id');
  }
}
