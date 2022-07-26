import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

import 'package:collection/collection.dart';

class ChannelManager extends CacheManager<Channel> {
  late final Guild _guild;
  Guild get guild => _guild;

  Future<Map<Snowflake, Channel>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/${_guild.id}/channels");
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

  Future<TextChannel?> createTextChannel ({ required String label, String? description, int? delay, int? position, CategoryChannel? categoryChannel, bool? nsfw,  List<PermissionOverwrite>? permissionOverwrites}) async {
    return await _create<TextChannel>(data: {
      'name': label,
      'topic': description,
      'type': ChannelType.guildText.value,
      'parent_id': categoryChannel?.id,
      'nsfw': nsfw ?? false,
      'rate_limit_per_user': delay ?? 0,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()).toList(),
    });
  }

  Future<VoiceChannel?> createVoiceChannel ({ required String label, int? position, CategoryChannel? categoryChannel, int? bitrate, int? maxUsers, List<PermissionOverwrite>? permissionOverwrites }) async {
    return await _create<VoiceChannel>(data: {
      'name': label,
      'type': ChannelType.guildVoice.value,
      'parent_id': categoryChannel?.id,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()).toList(),
      'bitrate': bitrate ?? 64000,
      'user_limit': maxUsers ?? 0,
    });
  }

  Future<CategoryChannel?> createCategoryChannel ({ required String label, int? position, List<PermissionOverwrite>? permissionOverwrites }) async {
    return await _create<CategoryChannel>(data: {
      'name': label,
      'type': ChannelType.guildCategory.value,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()).toList(),
    });
  }

  Future<T?> _create<T> ({ required dynamic data }) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.post(url: "/guilds/${_guild.id}/channels", payload: data);
    dynamic payload = jsonDecode(response.body);

    final ChannelType? type = ChannelType.values.firstWhereOrNull((element) => element.value == payload['type']);
    if (type != null && channels.containsKey(type)) {
      Channel Function(dynamic payload) item = channels[type] as Channel Function(dynamic payload);
      Channel channel = item(payload);

      channel.parent = payload['parent_id'] != null
        ? _guild.channels.cache.get<CategoryChannel>(payload['parent_id'])
        : null;

      cache.putIfAbsent(channel.id, () => channel);
      return channel as T;
    }
    return null;
  }
}
