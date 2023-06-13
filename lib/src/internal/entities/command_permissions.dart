import '../../../core/api.dart';

class CommandPermission {
  final Snowflake id;
  final CommandPermissionType type;
  final bool asAccess;

  CommandPermission({required this.id, required this.type, this.asAccess = true });

  Object toJson() {
    return {
      "id": id,
      "type": type.value,
      "permission": asAccess
    };
  }
}

enum CommandPermissionType {
  role(1),
  user(2),
  channel(3);

  final int value;
  const CommandPermissionType(this.value);
}