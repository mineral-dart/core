import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class ServerAnnouncementChannelFactory implements ChannelFactoryContract<ServerAnnouncementChannel> {
  @override
  ChannelType get type => ChannelType.guildAnnouncement;

  @override
  Future<ServerAnnouncementChannel> make(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final permissionOverwrites = await Future.wait(
      List.from(json['permission_overwrites'])
        .map((json) async => marshaller.serializers.channelPermissionOverwrite.serialize(json))
        .toList(),
    );

    return ServerAnnouncementChannel(
      id: Snowflake(json['id']),
      name: json['name'],
      position: json['position'],
      description: json['description'],
      permissionOverwrites: permissionOverwrites
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerAnnouncementChannel channel) async {
    final permissionOverwrites = await Future.wait(
      channel.permissionOverwrites
          .map((json) async => marshaller.serializers.channelPermissionOverwrite.deserialize(json))
          .toList(),
    );

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'position': channel.position,
      'permission_overwrites': permissionOverwrites
    };
  }
}
