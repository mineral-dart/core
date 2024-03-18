import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_forum_channel.dart';
import 'package:mineral/api/server/enums/forum_layout_types.dart';
import 'package:mineral/api/server/enums/sort_order_forum.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';
import 'package:mineral/domains/shared/helper.dart';

final class ServerForumChannelFactory implements ChannelFactoryContract<ServerForumChannel> {
  @override
  ChannelType get type => ChannelType.guildForum;

  @override
  Future<ServerForumChannel> make(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final permissionOverwrites = await Future.wait(
      List.from(json['permission_overwrites'])
          .map((json) async => marshaller.serializers.channelPermissionOverwrite.serialize(json))
          .toList(),
    );

    return ServerForumChannel(
      id: Snowflake(json['id']),
      name: json['name'],
      position: json['position'],
      description: json['topic'],
      sortOrder: Helper.createOrNull(
          field: json['default_sort_order'],
          fn: () => SortOrderType.values
              .firstWhere((element) => element.value == json['default_sort_order'])),
      layoutType: Helper.createOrNull(
          field: json['default_forum_layout'],
          fn: () => ForumLayoutType.values
              .firstWhere((element) => element.value == json['default_forum_layout'])),
      categoryId: json['parent_id'],
      permissionOverwrites: permissionOverwrites,
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerForumChannel channel) async {
    return {
      'id': channel.id.value,
      'type': channel.type.value,
    };
  }
}
