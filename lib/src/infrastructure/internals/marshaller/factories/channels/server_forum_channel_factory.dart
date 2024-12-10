import 'package:mineral/src/api/common/channel_properties.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/server/channels/server_forum_channel.dart';
import 'package:mineral/src/api/server/enums/forum_layout_types.dart';
import 'package:mineral/src/api/server/enums/sort_order_forum.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/channel_factory.dart';

final class ServerForumChannelFactory
    implements ChannelFactoryContract<ServerForumChannel> {
  @override
  ChannelType get type => ChannelType.guildForum;

  @override
  Future<Map<String, dynamic>> normalize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'type': json['type'],
      'position': json['position'],
      'name': json['name'],
      'description': json['topic'],
      'nsfw': json['nsfw'],
      'server_id': json['server_id'],
      'permission_overwrites': json['permission_overwrites'],
    };

    final cacheKey = marshaller.cacheKey.channel(json['id']);
    await marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ServerForumChannel> serialize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeCache(marshaller, json);
    return ServerForumChannel(
      properties,
      sortOrder: Helper.createOrNull(
          field: json['default_sort_order'],
          fn: () =>
              findInEnum(SortOrderType.values, json['default_sort_order'])),
      layoutType: Helper.createOrNull(
          field: json['default_forum_layout'],
          fn: () =>
              findInEnum(ForumLayoutType.values, json['default_forum_layout'])),
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(
      MarshallerContract marshaller, ServerForumChannel channel) async {
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
