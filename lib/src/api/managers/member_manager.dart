import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/managers/voice_manager.dart';

class MemberManager implements CacheManager<GuildMember> {
  @override
  Map<Snowflake, GuildMember> cache = {};

  Snowflake guildId;
  late Guild guild;

  MemberManager({ required this.guildId });

  @override
  Future<Map<Snowflake, GuildMember>> sync () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.get(url: "/guilds/$guildId/members");
    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      final Map<Snowflake, VoiceManager> voiceStateCache = cache.map((key, value) => MapEntry(key, value.voice));

      cache.clear();

      for(dynamic element in payload) {
        VoiceManager? voiceManager = voiceStateCache.get(element['user']['id']);

        GuildMember guildMember = GuildMember.from(
          user: User.from(element['user']),
          roles: guild.roles,
          guildId: guild.id,
          voice: voiceManager ?? VoiceManager(isMute: element['mute'], isDeaf: element['deaf'], isSelfMute: false, isSelfDeaf: false, hasVideo: false, hasStream: false, channel: null)
        );

        cache.putIfAbsent(guildMember.user.id, () => guildMember);
      }
    }

    return cache;
  }
}
