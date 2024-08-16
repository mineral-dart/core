import 'package:mineral/api/common/premium_tier.dart';
import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/private/user_assets.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class UserSerializer implements SerializerContract<User> {
  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    await _marshaller.serializers.userAssets.normalize({
      ...json,
      'user_id': json['id'],
    });

    final payload = {
      'id': json['id'],
      'username': json['username'],
      'discriminator': json['discriminator'],
      'flags': json['flags'],
      'public_flags': json['public_flags'],
      'avatar': json['avatar'],
      'is_bot': json['bot'],
      'system': json['system'],
      'mfa_enabled': json['mfa_enabled'],
      'locale': json['locale'],
      'verified': json['verified'],
      'email': json['email'],
      'premium_type': json['premium_type'],
      'assets': _marshaller.cacheKey.userAssets(json['id']),
    };

    final cacheKey = _marshaller.cacheKey.user(json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<User> serialize(Map<String, dynamic> json) async {
    final rawAssets = await _marshaller.cache.getOrFail(json['assets']);
    final assets = await _marshaller.serializers.userAssets.serialize(rawAssets);

    return User(
      id: json['id'],
      username: json['username'],
      discriminator: json['discriminator'],
      avatar: json['avatar'],
      bot: json['is_bot'],
      system: json['system'],
      mfaEnabled: json['mfa_enabled'],
      locale: json['locale'],
      verified: json['verified'],
      email: json['email'],
      flags: json['flags'],
      premiumType: PremiumTier.values
          .firstWhere((e) => e == json['premium_type'], orElse: () => PremiumTier.none),
      publicFlags: json['public_flags'],
      assets: assets,
      createdAt: Helper.createOrNull(
          field: json['created_at'], fn: () => DateTime.parse(json['created_at'])),
      // TODO: Implement presence deserialization
      presence: null,
    );
  }

  @override
  Map<String, dynamic> deserialize(User user) {
    return {
      'id': user.id,
      'username': user.username,
      'discriminator': user.discriminator,
      'flags': user.flags,
      'public_flags': user.publicFlags,
      'avatar': user.avatar,
      'is_bot': user.bot,
      'system': user.system,
      'mfa_enabled': user.mfaEnabled,
      'locale': user.locale,
      'verified': user.verified,
      'email': user.email,
      'premium_type': user.premiumType?.value,
      'created_at': user.createdAt?.toIso8601String(),
      // TODO: Implement presence serialization
    };
  }
}
