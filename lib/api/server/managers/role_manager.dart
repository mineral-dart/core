import 'package:mineral/api/server/role.dart';

final class RoleManager {
  final Map<String, Role> _roles;

  RoleManager(this._roles);

  Map<String, Role> get list => _roles;

  factory RoleManager.fromJson(Map<String, Role> guildRoles, List<String> json) {
    final Map<String, Role> roles = json.fold({}, (value, element) {
      final role = guildRoles[element];

      if (role == null) {
        // Todo add report case
        return value;
      }

      return {...value, role.id: role};
    });

    return RoleManager(roles);
  }
}
