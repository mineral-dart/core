import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/private/user_assets.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class UserSerializer implements SerializerContract<User> {
  @override
  User serializeRemote(Map<String, dynamic> json) => _serialize(json);

  @override
  User serializeCache(Map<String, dynamic> json) => _serialize(json);

  User _serialize(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      discriminator: json['discriminator'],
      avatar: json['avatar'],
      bot: json['bot'],
      system: json['system'],
      mfaEnabled: json['mfa_enabled'],
      locale: json['locale'],
      verified: json['verified'],
      email: json['email'],
      flags: json['flags'],
      premiumType: json['premium_type'],
      publicFlags: json['public_flags'],
      assets: UserAssets.fromJson(json),
      createdAt: json['created_at'],
      presence: json['presence'] != null ? Presence.fromJson(json['presence']) : null,
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
      'bot': user.bot,
      'system': user.system,
      'mfa_enabled': user.mfaEnabled,
      'locale': user.locale,
      'verified': user.verified,
      'email': user.email,
      'premium_type': user.premiumType?.value,
      'assets': {
        'avatar': user.assets.avatar?.hash,
        'avatar_decoration_data': {
          'sku_id': user.assets.avatarDecoration?.hash,
        },
        'banner': user.assets.banner?.hash,
      },
      'created_at': user.createdAt?.toIso8601String(),
      'presence': Helper.createOrNull(
        field: user.presence,
        fn: () => {
          'since': user.presence!.since?.toIso8601String(),
          'activities': user.presence!.activities.map((element) => {
            'name': element.name,
            'type': element.type.value,
            'url': element.url,
            'created_at': element.createdAt.toIso8601String(),
            'details': element.details,
            'state': element.state,
            'emoji': element.emoji != null ? {
              'name': element.emoji!.name,
              'id': element.emoji!.id,
              'animated': element.emoji!.animated,
            } : null,
          }).toList(),
          'status': user.presence!.status.value,
          'afk': user.presence!.afk,
        }
      ),
    };
  }
}
