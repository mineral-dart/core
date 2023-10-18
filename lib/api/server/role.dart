import 'package:mineral/api/common/emojis/emoji.dart';
import 'package:mineral/api/common/resources/color.dart';
import 'package:mineral/api/common/resources/picture.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/helper.dart';
import 'package:mineral/api/server/contracts/emoji_contracts.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';
import 'package:mineral/api/server/resources/permission.dart';
import 'package:mineral/api/server/resources/role_tag.dart';

final class Role implements RoleContract {
  @override
  final Snowflake id;

  @override
  Color color;

  @override
  EmojiContract? emoji;

  @override
  int flags;

  @override
  Picture? icon;

  @override
  bool isHoisted;

  @override
  bool isManaged;

  @override
  bool isMentionable;

  @override
  String name;

  @override
  List<Permission> permissions;

  @override
  int position;

  @override
  RoleTag? tags;

  Role._({
    required this.id,
    required this.color,
    required this.emoji,
    required this.flags,
    required this.icon,
    required this.isHoisted,
    required this.isManaged,
    required this.isMentionable,
    required this.name,
    required this.permissions,
    required this.position,
    required this.tags,
  });

  factory Role.fromWss(final payload) {
    return Role._(
      id: Snowflake(payload['id']),
      color: Helper.rgbToColor(payload['color']),
      emoji: payload['unicode_emoji'] != null ? Emoji.unicode(payload['unicode_emoji']) : null,
      flags: payload['flags'],
      icon: payload['icon'] != null ? Picture(label: payload['icon']) : null,
      isHoisted: payload['hoist'],
      isManaged: payload['managed'],
      isMentionable: payload['mentionable'],
      name: payload['name'],
      permissions: Helper.bitfieldToPermissions(int.parse(payload['permissions'])),
      position: payload['position'],
      tags: payload['tags'] != null ? RoleTag.from(payload['tags']) : null,
    );
  }
}