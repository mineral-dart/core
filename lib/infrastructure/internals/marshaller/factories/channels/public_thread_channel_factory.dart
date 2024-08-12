import 'package:mineral/api/common/thread_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';

final class PublicThreadChannelFactory implements ChannelFactoryContract<ThreadChannel> {
  @override
  ChannelType get type => ChannelType.guildPublicThread;

  @override
  Future<ThreadChannel> serializeRemote(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ThreadProperties.serializeRemote(marshaller, json);
    return ThreadChannel(properties, ChannelType.guildPublicThread);
  }

  @override
  Future<ThreadChannel> serializeCache(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ThreadProperties.serializeCache(marshaller, json);
    return ThreadChannel(properties, ChannelType.guildPublicThread);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ThreadChannel channel) async {
    return {
      'id': channel.id.value,
      'type': channel.type.value,
    };
  }
}
