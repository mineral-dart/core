import 'package:mineral/api/common/partial_emoji.dart';
import 'package:mineral/api/server/channels/guild_category_channel.dart';
import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/enums/forum_layout_types.dart';
import 'package:mineral/api/server/enums/sort_order_forum.dart';
import 'package:mineral/api/server/guild.dart';
import 'package:mineral/domains/shared/utils.dart';

final class GuildForumChannel implements GuildChannel {
  @override
  final String id;

  @override
  final String name;

  @override
  final int position;

  @override
  final String guildId;

  @override
  late final Guild guild;

  final String? description;

  final SortOrderType? sortOrder;

  final ForumLayoutType? layoutType;

  final String? categoryId;

  late final GuildCategoryChannel? category;

  GuildForumChannel({
    required this.id,
    required this.name,
    required this.position,
    required this.guildId,
    required this.description,
    required this.sortOrder,
    required this.layoutType,
    required this.categoryId,
  });

  factory GuildForumChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return GuildForumChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      guildId: guildId,
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
