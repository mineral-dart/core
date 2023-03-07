import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';

class UserDecoration {
  final String _discriminator;

  final ImageFormater? _avatar;
  final ImageFormater? _avatarDecoration;

  UserDecoration(this._discriminator, this._avatar, this._avatarDecoration);

  ImageFormater? get avatar => _avatar;
  ImageFormater? get avatarDecoration => _avatarDecoration;

  /// ### Returns the absolute url to the user's avatar
  String get defaultAvatarUrl => _avatar != null
    ? '${_avatar?.url}'
    : '${Constants.cdnUrl}/embed/avatars/${int.parse(_discriminator) % 5 }.png';
}