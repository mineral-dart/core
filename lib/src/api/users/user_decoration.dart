import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';

class UserDecoration {
  final String _discriminator;

  final ImageFormater? _avatar;
  final ImageFormater? _avatarDecoration;

  UserDecoration(this._discriminator, this._avatar, this._avatarDecoration);

  /// An optional [ImageFormater] instance representing the [User]'s avatar image.
  ImageFormater? get avatar => _avatar;

  /// An optional [ImageFormater] instance representing the decoration of the [User]'s avatar image.
  ImageFormater? get avatarDecoration => _avatarDecoration;

  /// This function is a getter that returns the default avatar URL of a [User] as [String].
  ///
  /// If the user has an avatar, it returns the URL of that avatar.
  /// Otherwise, it returns a URL for the default avatar image based on the [User]'s discriminator.
  String get defaultAvatarUrl => _avatar != null
    ? '${_avatar?.url}'
    : '${Constants.cdnUrl}/embed/avatars/${int.parse(_discriminator) % 5 }.png';
}