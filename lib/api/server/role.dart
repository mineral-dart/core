import 'package:mineral/api/common/snowflake.dart';

final class Role {
  final Snowflake id;
  final String name;
  final int color;
  final bool hoist;
  final int position;
  final int? permissions;
  final bool managed;
  final bool mentionable;
  final int flags;

  Role({
    required this.id,
    required this.name,
    required this.color,
    required this.hoist,
    required this.position,
    required this.permissions,
    required this.managed,
    required this.mentionable,
    required this.flags,
  });
}
