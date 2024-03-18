import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/enums/forum_layout_types.dart';
import 'package:mineral/api/server/enums/sort_order_forum.dart';
import 'package:mineral/domains/shared/helper.dart';

final class ServerForumChannel extends ServerChannel {
  final String? description;

  final SortOrderType? sortOrder;

  final ForumLayoutType? layoutType;

  final String? categoryId;

  late final ServerCategoryChannel? category;

  ServerForumChannel({
    required Snowflake id,
    required String name,
    required int position,
    required List<ChannelPermissionOverwrite> permissionOverwrites,
    required this.description,
    required this.sortOrder,
    required this.layoutType,
    required this.categoryId,
  }) : super(id, ChannelType.guildForum, name, position, permissionOverwrites);
}
