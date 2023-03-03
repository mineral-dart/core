import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
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
  List<Permission>? allow;
  List<Permission>? deny;

  PermissionOverwrite({
    required this.id,
    required this.type,
    this.allow,
    this.deny
  });

  dynamic toJson () {
    if (allow == null && deny == null) {
      throw InvalidParameterException('You must specify the authorisation or prohibition');
    }
    
    return {
      'id': id,
      'type': type.value,
      'allow': allow != null ? Helper.reduceRolePermissions(allow!).toString() : null,
      'deny': deny != null ? Helper.reduceRolePermissions(deny!).toString() : null
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
