import 'package:mineral/src/api/common/premium_tier.dart';
import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/user_client.dart';
import 'package:mineral/src/api/private/user_assets.dart';

final class User implements UserClient {
  final Snowflake id;
  final String username;
  final String discriminator;
  final String? avatar;
  final bool? bot;
  final bool? system;
  final bool? mfaEnabled;
  final String? locale;
  final bool? verified;
  final String? email;
  final int? flags;
  final PremiumTier? premiumType;
  final int? publicFlags;
  final UserAssets assets;
  final DateTime? createdAt;
  Presence? presence;

  User({
    required this.id,
    required this.username,
    required this.discriminator,
    required this.avatar,
    required this.bot,
    required this.system,
    required this.mfaEnabled,
    required this.locale,
    required this.verified,
    required this.email,
    required this.flags,
    required this.premiumType,
    required this.publicFlags,
    required this.assets,
    required this.createdAt,
    required this.presence,
  });
}
