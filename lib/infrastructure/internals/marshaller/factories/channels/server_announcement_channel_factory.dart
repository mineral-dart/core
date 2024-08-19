import 'dart:async';

import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';

final class ServerAnnouncementChannelFactory implements ChannelFactoryContract<ServerAnnouncementChannel> {
  @override
  ChannelType get type => ChannelType.guildAnnouncement;

  @override
  Future<Map<String, dynamic>> normalize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'type': json['type'],
      'position': json['position'],
      'name': json['name'],
      'description': json['topic'],
      'nsfw': json['nsfw'],
      'server_id': json['server_id'],
      'category_id': json['parent_id'],
      'permission_overwrites': json['permission_overwrites'],
    };

    final cacheKey = marshaller.cacheKey.channel(json['id']);
    await marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ServerAnnouncementChannel> serialize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeCache(marshaller, json);
    return ServerAnnouncementChannel(properties);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerAnnouncementChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map((element) async => marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'position': channel.position,
      'permission_overwrites': permissions,
      'name': channel.name,
      'topic': channel.description,
      'nsfw': channel.isNsfw,
      'parent_id': channel.categoryId,
      'server_id': channel.serverId,
    };
  }
}
