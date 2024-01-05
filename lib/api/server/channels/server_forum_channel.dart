import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/enums/forum_layout_types.dart';
import 'package:mineral/api/server/enums/sort_order_forum.dart';
import 'package:mineral/domains/shared/utils.dart';

final class ServerForumChannel extends ServerChannel {
  final String? description;

  final SortOrderType? sortOrder;

  final ForumLayoutType? layoutType;

  final String? categoryId;

  late final ServerCategoryChannel? category;

  ServerForumChannel({
    required String id,
    required String name,
    required int position,
    required this.description,
    required this.sortOrder,
    required this.layoutType,
    required this.categoryId,
  }) : super(id, name, position);

  factory ServerForumChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return ServerForumChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      description: json['topic'],
      sortOrder: createOrNull(
          field: json['default_sort_order'],
          fn: () => SortOrderType.values
              .firstWhere((element) => element.toString() == json['default_sort_order'])),
      layoutType: createOrNull(
          field: json['default_forum_layout'],
          fn: () => ForumLayoutType.values
              .firstWhere((element) => element.toString() == json['default_forum_layout'])),
      categoryId: json['parent_id'],
    );
  }
}
