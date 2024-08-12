import 'package:mineral/api/common/thread_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ThreadChannelSerializer implements SerializerContract<ThreadChannel> {
  final MarshallerContract marshaller;

  ThreadChannelSerializer(this.marshaller);

  @override
  Future<ThreadChannel> serializeRemote(Map<String, dynamic> json) async {
    final properties = await ThreadProperties.serializeRemote(marshaller, json);
    return ThreadChannel(properties, ChannelType.values.firstWhere((element) => element.value == json['type']));
  }

  @override
  Future<ThreadChannel> serializeCache(Map<String, dynamic> json) async {
    final properties = await ThreadProperties.serializeCache(marshaller, json);
    return ThreadChannel(properties, ChannelType.values.firstWhere((element) => element.value == json['type']));
  }

  @override
  Future<Map<String, dynamic>> deserialize(ThreadChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map((element) async =>
        marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'name': channel.name,
      'guild_id': channel.guildId,
      'permission_overwrites': permissions,
      'parent_id': channel.channelId,
    };
  }
}
