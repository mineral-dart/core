import 'package:mineral/src/api/common/channel_properties.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/server/channels/server_voice_channel.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/channel_factory.dart';

final class ServerVoiceChannelFactory
    implements ChannelFactoryContract<ServerVoiceChannel> {
  @override
  ChannelType get type => ChannelType.guildVoice;

  @override
  Future<Map<String, dynamic>> normalize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'type': json['type'],
      'position': json['position'],
      'name': json['name'],
      'server_id': json['guild_id'],
      'parent_id': json['parent_id'],
      'permission_overwrites': json['permission_overwrites'],
    };

    final cacheKey = marshaller.cacheKey.channel(json['id']);
    await marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ServerVoiceChannel> serialize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeCache(marshaller, json);
    return ServerVoiceChannel(properties);
  }

  @override
  Future<Map<String, dynamic>> deserialize(
      MarshallerContract marshaller, ServerVoiceChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map(
        (element) async => marshaller.serializers.channelPermissionOverwrite
            .deserialize(element)));

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'name': channel.name,
      'position': channel.position,
      'server_id': channel.serverId,
      'permission_overwrites': permissions,
      'parent_id': channel.categoryId,
    };
  }
}
