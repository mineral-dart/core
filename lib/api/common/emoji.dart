import 'package:mineral/api/common/partial_emoji.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/role.dart';

final class Emoji extends PartialEmoji {
  final String? globalName;
  final Map<String, Role> roles;
  final bool managed;
  final bool animated;
  final bool available;

  Emoji({
    required String id,
    required String name,
    required this.globalName,
    required this.roles,
    required this.managed,
    required this.animated,
    required this.available,
  }) : super(id, name);

  factory Emoji.fromJson(
      {required Map<String, Role> guildRoles, required Map<String, dynamic> json}) {
    final Map<String, Role> roles = List<String>.from(json['roles']).fold({}, (value, element) {
      final role = guildRoles[element];

      if (role == null) {
        // Todo add report case
        return value;
      }

      return {...value, role.id: role};
    });

    return Emoji(
      id: json['id'],
      name: json['name'],
      globalName: json['global_name'],
      roles: roles,
      managed: json['managed'],
      animated: json['animated'],
      available: json['available'],
    );
  }
}
