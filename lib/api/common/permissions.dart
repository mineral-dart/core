import 'package:mineral/api/common/permission.dart';

final class Permissions {
  final int raw;
  final List<Permission> permissions;

  Permissions(this.raw, this.permissions);

  bool has(Permission permission) => permissions.contains(permission);

  bool hasAll(List<Permission> permissions) => permissions.every((permission) => has(permission));

  bool hasAny(List<Permission> permissions) => permissions.any((permission) => has(permission));

  bool hasNone(List<Permission> permissions) => permissions.every((permission) => !has(permission));

  factory Permissions.fromInt(int raw) {
    final permissions = Permission.values.where((permission) => raw & permission.value == permission.value).toList();
    return Permissions(raw, permissions);
  }
}