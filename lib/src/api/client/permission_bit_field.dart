import 'package:mineral/core/api.dart';
import 'package:mineral/src/helper.dart';

class PermissionBitField {
  final List<int> _permissions;
  final bool _isOwner;

  PermissionBitField (this._permissions, this._isOwner);

  List<ClientPermission> get values => _permissions.fold([], (previousValue, element) => [
    ...previousValue,
    ...Helper.bitfieldToPermissions(element)
  ]);

  bool has(ClientPermission permission) => _isOwner ? true : values.contains(permission);
}