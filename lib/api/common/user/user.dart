import 'package:mineral/api/common/contracts/user_contract.dart';
import 'package:mineral/api/common/contracts/user_decoration_contract.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/user/user_decoration.dart';

final class User implements UserContract {
  @override
  final Snowflake id;

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
  final int publicFlags;

  @override
  final int flags;

  @override
  final String? locale;

  User._({
    required this.id,
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

  factory User.fromWss(Map<String, dynamic> payload) =>
   User._(
      id: Snowflake(payload['id']),
      username: payload['username'],
      globalName: payload['global_name'],
      discriminator: payload['discriminator'],
      decoration: UserDecoration(
        accentColor: payload['accent_color'],
        banner: payload['banner'],
        avatar: payload['avatar'],
      ),
      isBot: payload['bot'] ?? false,
      isSystem: payload['system'] ?? false,
      isVerified: payload['verified'] ?? false,
      publicFlags: payload['public_flags'] ?? 0,
      flags: payload['flags'] ?? 0,
      locale: payload['locale'],
    );
}