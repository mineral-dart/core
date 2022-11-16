import 'package:mineral/core/api.dart';
import 'package:mineral/src/helper.dart';

enum PermissionOverwriteType {
  role(0),
  member(1);

  final int value;
  const PermissionOverwriteType(this.value);
}

class PermissionOverwrite {
  Snowflake id;
  PermissionOverwriteType type;
  List<Permission> allow;
  List<Permission> deny;

  PermissionOverwrite({
    required this.id,
    required this.type,
    required this.allow,
    required this.deny
  });

  dynamic toJSON() {
    return {
      'id': id,
      'type': type.value,
      'allow': Helper.reduceRolePermissions(allow).toString(),
      'deny': Helper.reduceRolePermissions(deny).toString()
    };
  }

  factory PermissionOverwrite.from({required dynamic payload}) {
    return PermissionOverwrite(
      id: payload['id'],
      type: payload['type'] is String
          ? PermissionOverwriteType.values.firstWhere((element) => element.name == payload['type'])
          : PermissionOverwriteType.values.firstWhere((element) => element.value == payload['type']),
      allow: Helper.bitfieldToPermissions(payload['allow']),
      deny: Helper.bitfieldToPermissions(payload['deny']),
    );
  }
}
