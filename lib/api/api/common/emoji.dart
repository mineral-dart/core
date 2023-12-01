import 'package:mineral/api/api/common/partial_emoji.dart';
import 'package:mineral/api/api/private/user.dart';
import 'package:mineral/api/api/server/role.dart';

final class Emoji extends PartialEmoji {
  final String? globalName;
  final List<Role> roles;
  final User? user;
  final bool managed;
  final bool animated;
  final bool available;

  Emoji({
    required String id,
    required String name,
    required this.globalName,
    required this.roles,
    required this.user,
    required this.managed,
    required this.animated,
    required this.available,
  }) : super(
          id: id,
          name: name,
        );
}
