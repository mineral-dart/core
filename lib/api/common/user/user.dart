import 'package:mineral/api/common/contracts/user_contract.dart';
import 'package:mineral/api/common/contracts/user_decoration_contract.dart';

final class User implements UserContract {
  @override
  final String username;

  @override
  final String? globalName;

  @override
  final String? discriminator;

  @override
  final UserDecorationContract decoration;

  @override
  final bool isBot;

  @override
  final bool isSystem;

  @override
  final bool isVerified;

  @override
  final List<dynamic> publicFlags;

  @override
  final List<dynamic> flags;

  @override
  final String? locale;

  User({
    required this.username,
    required this.globalName,
    required this.discriminator,
    required this.decoration,
    required this.isBot,
    required this.isSystem,
    required this.isVerified,
    required this.publicFlags,
    required this.flags,
    required this.locale,
  });
}