import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_stage_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';

final class ServerStageChannelFactory implements ChannelFactoryContract<ServerStageChannel> {
  @override
  ChannelType get type => ChannelType.guildStageVoice;

  @override
  Future<ServerStageChannel> serializeRemote(
      MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeRemote(marshaller, json);

    return ServerStageChannel(properties);
  }

  @override
  Future<ServerStageChannel> serializeCache(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> deserialize(
      MarshallerContract marshaller, ServerStageChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map(
        (element) async => marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'name': channel.name,
      'position': channel.position,
      'guild_id': channel.guildId,
      'topic': channel.description,
      'permission_overwrites': permissions,
      // 'parent_id': channel.category?.id,
    };
  }
}
