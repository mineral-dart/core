import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';

final class RoleManager {
  final Map<Snowflake, Role> _roles;

  RoleManager(this._roles);

  Map<Snowflake, Role> get list => _roles;

  Role getOrFail(String id) => _roles.values
      .firstWhere((element) => element.id == id, orElse: () => throw Exception('Role not found'));

  factory RoleManager.fromList(List<Role> payload) {
    final roles = Map<Snowflake, Role>.from(payload.fold({}, (value, element) {
      return {...value, element.id: element};
    }));

    return RoleManager(roles);
  }
}
