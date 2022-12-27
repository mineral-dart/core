import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class MemberManager extends CacheManager<GuildMember> with Container {
  late final Guild _guild;
  Guild get guild => _guild;

  Future<Map<Snowflake, GuildMember>> sync () async {
    Response response = await container.use<HttpService>().get(url: "/guilds/${_guild.id}/members");
    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      final Map<Snowflake, VoiceManager> voiceStateCache = cache.map((key, value) => MapEntry(key, value.voice));

      cache.clear();

      for(dynamic element in payload) {
        VoiceManager? voiceManager = voiceStateCache.get(element['user']['id']);

        GuildMember guildMember = GuildMember.from(
          user: User.from(element['user']),
          roles: _guild.roles,
          guild: _guild,
          voice: voiceManager ?? VoiceManager.empty(element['deaf'], element['mute'], element['user']['id'], _guild.id)
        );

        cache.putIfAbsent(guildMember.user.id, () => guildMember);
      }
    }

    return cache;
  }
}
