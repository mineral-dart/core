import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_forum_channel.dart';
import 'package:mineral/api/server/enums/forum_layout_types.dart';
import 'package:mineral/api/server/enums/sort_order_forum.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/commons/utils.dart';

final class ServerForumChannelFactory implements ChannelFactoryContract<ServerForumChannel> {
  @override
  ChannelType get type => ChannelType.guildForum;

  @override
  Future<ServerForumChannel> make(
      MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.make(marshaller, json);

    return ServerForumChannel(
      properties,
      sortOrder: Helper.createOrNull(
          field: json['default_sort_order'],
          fn: () => findInEnum(SortOrderType.values, json['default_sort_order'])),
      layoutType: Helper.createOrNull(
          field: json['default_forum_layout'],
          fn: () => findInEnum(ForumLayoutType.values, json['default_forum_layout'])),
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(
      MarshallerContract marshaller, ServerForumChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map((element) async =>
        marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'name': channel.name,
      'position': channel.position,
      'guild_id': channel.guildId,
      'permission_overwrites': permissions,
    };
  }
}
