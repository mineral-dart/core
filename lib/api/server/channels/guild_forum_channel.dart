import 'package:mineral/api/common/partial_emoji.dart';
import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/enums/forum_layout_types.dart';
import 'package:mineral/api/server/enums/sort_order_forum.dart';
import 'package:mineral/api/server/guild.dart';

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
  final Guild guild;

  final String description;

  final SortOrderType? sortOrder;

  final ForumLayoutType? layoutType;

  final PartialEmoji? defaultEmoji;

  final String? categoryId;

  final String? category;

  GuildForumChannel({
    required this.id,
    required this.name,
    required this.position,
    required this.guildId,
    required this.guild,
    required this.description,
    required this.sortOrder,
    required this.layoutType,
    required this.defaultEmoji,
    required this.categoryId,
    required this.category,
  });
}
