import 'package:mineral/api/common/resources/color.dart';
import 'package:mineral/api/common/resources/picture.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/emoji_contracts.dart';
import 'package:mineral/api/server/resources/permission.dart';
import 'package:mineral/api/server/resources/role_tag.dart';

abstract interface class RoleContract {
  abstract final Snowflake id;
  abstract String name;
  abstract Color color;
  abstract bool isHoisted;
  abstract Picture? icon;
  abstract EmojiContract? emoji;
  abstract int position;
  abstract List<Permission> permissions;
  abstract bool isManaged;
  abstract bool isMentionable;
  abstract RoleTag? tags;
  abstract int flags;
}