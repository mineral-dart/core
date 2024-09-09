import 'package:mineral/src/api/common/partial_emoji.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/role.dart';

final class Emoji extends PartialEmoji {
  final Map<Snowflake, Role> roles;
  final bool managed;
  final bool available;

  Emoji({
    required Snowflake id,
    required String name,
    required this.roles,
    required this.managed,
    required this.available,
    required bool animated,
  }) : super(id, name, animated);
}
