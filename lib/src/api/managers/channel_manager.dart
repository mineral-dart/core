import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class ChannelManager implements CacheManager<Channel> {
  @override
  Map<Snowflake, Channel> cache = Map();

  Snowflake? guildId;
  late Guild? guild;

  ChannelManager({ required this.guildId });

  @override
  Future<Map<Snowflake, Channel>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/$guildId/channels");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      if (channels.containsKey(element['type'])) {
        Channel Function(dynamic payload) item = channels[element['type']] as Channel Function(dynamic payload);
        Channel channel = item(element);

        cache.putIfAbsent(channel.id, () => channel);
      }
    }

    return cache;
  }

  Future<TextChannel?> createTextChannel ({ required String label, String? description, int? delay, int? position, CategoryChannel? categoryChannel, bool? nsfw }) async {
    return await _create<TextChannel>(data: {
      'name': label,
      'topic': description,
      'type': ChannelType.guildText.value,
      'parent_id': categoryChannel?.id,
      'nsfw': nsfw ?? false,
      'rate_limit_per_user': delay ?? 0,
      'permission_overwrites': [],
    });
  }

  Future<VoiceChannel?> createVoiceChannel ({ required String label, int? position, CategoryChannel? categoryChannel, int? bitrate, int? maxUsers }) async {
    return await _create<VoiceChannel>(data: {
      'name': label,
      'type': ChannelType.guildVoice.value,
      'parent_id': categoryChannel?.id,
      'permission_overwrites': [],
      'bitrate': bitrate ?? 64000,
      'user_limit': maxUsers ?? 0,
    });
  }

  Future<CategoryChannel?> createCategoryChannel ({ required String label, int? position }) async {
    return await _create<CategoryChannel>(data: {
      'name': label,
      'type': ChannelType.guildCategory.value,
      'permission_overwrites': [],
    });
  }

  Future<T?> _create<T> ({ required dynamic data }) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.post(url: "/guilds/$guildId/channels", payload: data);
    dynamic payload = jsonDecode(response.body);

    if (channels.containsKey(payload['type'])) {
      Channel Function(dynamic payload) item = channels[payload['type']] as Channel Function(dynamic payload);
      Channel channel = item(payload);

      // Define deep properties
      channel.guildId = guildId;
      channel.guild = guild;
      channel.parent = channel.parentId != null ? guild?.channels.cache.get<CategoryChannel>(channel.parentId) : null;

      cache.putIfAbsent(channel.id, () => channel);
      return channel as T;
    }
    return null;
  }
}
