import 'package:mineral/api.dart';
import 'package:mineral/helper.dart';

enum PermissionOverwriteType {
  role(0),
  user(1);

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
  
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'type': type.value,
      'allow': Helper.reduceRolePermissions(allow),
      'deny': Helper.reduceRolePermissions(deny)
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