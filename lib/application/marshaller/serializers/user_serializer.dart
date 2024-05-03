import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/private/user_assets.dart';
import 'package:mineral/application/marshaller/marshaller.dart';
import 'package:mineral/application/marshaller/types/serializer.dart';

final class UserSerializer implements SerializerContract<User> {
  final MarshallerContract _marshaller;

  UserSerializer(this._marshaller);

  @override
  Future<User> serialize(Map<String, dynamic> json) async {
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
    };
  }
}
