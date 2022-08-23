import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

import 'package:collection/collection.dart';

class ChannelManager extends CacheManager<GuildChannel> {
  late final Guild _guild;
  Guild get guild => _guild;

  Future<Map<Snowflake, GuildChannel>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/${_guild.id}/channels");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      if (channels.containsKey(element['type'])) {
        GuildChannel Function(dynamic payload) item = channels[element['type']] as GuildChannel Function(dynamic payload);
        GuildChannel channel = item(element);

        cache.putIfAbsent(channel.id, () => channel);
      }
    }

    return cache;
  }

  Future<TextChannel?> createTextGuildChannel ({ required String label, String? description, int? delay, int? position, CategoryGuildChannel? categoryGuildChannel, bool? nsfw,  List<PermissionOverwrite>? permissionOverwrites}) async {
    return await create<TextChannel>(data: {
      'name': label,
      'topic': description,
      'type': ChannelType.guildText.value,
      'parent_id': categoryGuildChannel?.id,
      'nsfw': nsfw ?? false,
      'rate_limit_per_user': delay ?? 0,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()).toList(),
    });
  }

  Future<VoiceChannel?> createVoiceGuildChannel ({ required String label, int? position, CategoryGuildChannel? categoryGuildChannel, int? bitrate, int? maxUsers, List<PermissionOverwrite>? permissionOverwrites }) async {
    return await create<VoiceChannel>(data: {
      'name': label,
      'type': ChannelType.guildVoice.value,
      'parent_id': categoryGuildChannel?.id,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()).toList(),
      'bitrate': bitrate ?? 64000,
      'user_limit': maxUsers ?? 0,
    });
  }

  Future<CategoryChannel?> createCategoryGuildChannel ({ required String label, int? position, List<PermissionOverwrite>? permissionOverwrites }) async {
    return await create(ChannelBuilder({
      'name': label,
      'type': ChannelType.guildCategory.value,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()).toList(),
    }));
  }

  Future<T?> create<T> (ChannelBuilder channel) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.post(url: "/guilds/${_guild.id}/channels", payload: channel.payload);
    dynamic payload = jsonDecode(response.body);




    return null;
  }
}
