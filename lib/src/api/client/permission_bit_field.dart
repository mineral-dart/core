import 'package:mineral/core/api.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral_ioc/ioc.dart';

class PermissionBitField {
  final GuildMember _member;
  final List<int> _permissions;
  final bool _isOwner;

  PermissionBitField (this._member, this._permissions, this._isOwner);

  List<ClientPermission> get values => _permissions.fold([], (previousValue, element) => [
    ...previousValue,
    ...Helper.bitfieldToPermissions(element)
  ]);

  bool has (ClientPermission permission) => _isOwner ? true : values.contains(permission);

  bool get isManageable {
    if (_member.user.id == _member.guild.owner.id) return false;
    if (_member.user.id == ioc.use<MineralClient>().user.id) return false;
    if (ioc.use<MineralClient>().user.id == _member.guild.owner.id) return true;

    return _member.roles.highest != null
      ? ioc.use<MineralClient>().user.toGuildMember(_member.id)!.roles.highest!.position < _member.roles.highest!.position
      : true;
  }
}