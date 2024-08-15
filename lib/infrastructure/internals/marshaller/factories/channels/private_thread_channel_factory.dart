import 'package:mineral/api/common/thread_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';

final class PrivateThreadChannelFactory implements ChannelFactoryContract<ThreadChannel> {
  @override
  ChannelType get type => ChannelType.guildPrivateThread;

  @override
  Future<ThreadChannel> serializeRemote(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ThreadProperties.serializeRemote(marshaller, json);
    return ThreadChannel(properties, ChannelType.guildPrivateThread);
  }

  @override
  Future<ThreadChannel> serializeCache(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ThreadProperties.serializeCache(marshaller, json);
    return ThreadChannel(properties, ChannelType.guildPrivateThread);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ThreadChannel channel) async {
    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'name': channel.name,
      'description': channel.description,
      'guild_id': channel.guildId.value,
      'owner_id': channel.owner.id.value,
      'thread_metadata': {
        'archived': channel.metadata.archived,
        'auto_archive_duration': channel.metadata.autoArchiveDuration,
        'locked': channel.metadata.locked,
        'archive_timestamp': channel.metadata.archiveTimestamp,
        'invitable': channel.metadata.invitable,
        'is_public': channel.metadata.isPublic,
      },
      'thread_member': {
        'id': channel.owner.id.value,
        'member': await marshaller.serializers.member.deserialize(channel.owner.member),
        'join_timestamp': channel.owner.joinedAt.toIso8601String(),
        'flags': channel.owner.flags,
      },
      'members': await Future.wait(channel.members.map((member) async {
        return {
          'id': member.id.value,
          'member': await marshaller.serializers.member.deserialize(member.member),
          'join_timestamp': member.joinedAt.toIso8601String(),
          'flags': member.flags,
        };
      })),
    };
  }
}
