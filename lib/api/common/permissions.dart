import 'package:mineral/api/common/permission.dart';

final class Permissions {
  final int raw;
  final List<Permission> _permissions;

  List<Permission> get list => _permissions;

  Permissions(this.raw, this._permissions);

  bool has(Permission permission) => _permissions.contains(permission);

  factory Permissions.fromInt(int raw) {
    final permissions = Permission.values.where((permission) => raw & permission.value == permission.value).toList();
    return Permissions(raw, permissions);
  }
}
