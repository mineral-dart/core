import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_stage_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';

final class ServerStageChannelFactory implements ChannelFactoryContract<ServerStageChannel> {
  @override
  ChannelType get type => ChannelType.guildStageVoice;

  @override
  Future<Map<String, dynamic>> normalize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'type': json['type'],
      'position': json['position'],
      'name': json['name'],
      'description': json['topic'],
      'server_id': json['server_id'],
      'parent_id': json['parent_id'],
      'permission_overwrites': json['permission_overwrites'],
    };

    final cacheKey = marshaller.cacheKey.channel(json['id']);
    await marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ServerStageChannel> serialize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeCache(marshaller, json);
    return ServerStageChannel(properties);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerStageChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map((element) async => marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'name': channel.name,
      'position': channel.position,
      'server_id': channel.serverId,
      'topic': channel.description,
      'permission_overwrites': permissions,
      'parent_id': channel.categoryId,
    };
  }
}
