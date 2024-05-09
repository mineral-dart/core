import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';
import 'package:mineral/infrastructure/commons/helper.dart';

final class ServerAnnouncementChannelFactory
    implements ChannelFactoryContract<ServerAnnouncementChannel> {
  @override
  ChannelType get type => ChannelType.guildAnnouncement;

  @override
  Future<ServerAnnouncementChannel> make(MarshallerContract marshaller, String guildId,
      Map<String, dynamic> json) async {
    final properties = await ChannelProperties.make(marshaller, json);
    final categoryChannel = await Helper.createOrNullAsync(
        field: json['parent_id'],
        fn: () async {
          final rawCategory = await marshaller.cache.getOrFail(json['parent_id']);
          return marshaller.serializers.channels.serialize(rawCategory) as ServerCategoryChannel;
        }
    );

    return ServerAnnouncementChannel(properties,
      category: categoryChannel,
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller,
      ServerAnnouncementChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map((element) async =>
        marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'position': channel.position,
      'permission_overwrites': permissions,
      'name': channel.name,
      'topic': channel.description,
      'nsfw': channel.isNsfw,
      'parent_id': channel.category?.id,
      'guild_id': channel.guildId,
    };
  }
}
