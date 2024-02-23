import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';

final class RoleManager {
  final Map<Snowflake, Role> _roles;

  RoleManager(this._roles);

  Map<Snowflake, Role> get list => _roles;

  factory RoleManager.fromJson(Map<Snowflake, Role> guildRoles, List<String> json) {
    final Map<Snowflake, Role> roles = json.fold({}, (value, element) {
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
