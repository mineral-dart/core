import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class MemberManager extends CacheManager<GuildMember> {
  late final Guild _guild;
  Guild get guild => _guild;

  Future<Map<Snowflake, GuildMember>> sync () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.get(url: "/guilds/${_guild.id}/members");
    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      final Map<Snowflake, VoiceManager> voiceStateCache = cache.map((key, value) => MapEntry(key, value.voice));

      cache.clear();

      for(dynamic element in payload) {
        VoiceManager? voiceManager = voiceStateCache.get(element['user']['id']);
        VoiceChannel? voiceChannel = guild.channels.cache.get(payload['channel_id']);

        GuildMember guildMember = GuildMember.from(
          user: User.from(element['user']),
          roles: _guild.roles,
          guild: _guild,
          voice: voiceManager ?? VoiceManager.from(payload, null, voiceChannel)
        );

        guildMember.voice.member = guildMember;

        cache.putIfAbsent(guildMember.user.id, () => guildMember);
      }
    }

    return cache;
  }
}
