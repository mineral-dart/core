import 'package:mineral/api/common/avatar_decoration.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';
import 'package:mineral/domains/shared/helper.dart';

final class MemberSerializer implements SerializerContract<Member> {
  final MarshallerContract _marshaller;

  MemberSerializer(this._marshaller);

  @override
  Future<Member> serialize(Map<String, dynamic> json) async {
    final serverRoles = json.entries.firstWhere((element) => element.key == 'guild_roles',
        orElse: () => throw FormatException('Server roles not found in member structure'));

    return Member(
      id: json['user']['id'],
      username: json['user']['nick'] ?? json['user']['username'],
      nickname: json['nick'] ?? json['user']['display_name'],
      globalName: json['user']['global_name'],
      discriminator: json['user']['discriminator'],
      avatar: json['avatar'],
      avatarDecoration: Helper.createOrNull(
          field: json['user']?['avatar_decoration_data'],
          fn: () => AvatarDecoration.fromJson(json['user']['avatar_decoration_data'])),
      flags: json['flags'],
      premiumSince: Helper.createOrNull(
          field: json['premium_since'], fn: () => DateTime.parse(json['premium_since'])),
      publicFlags: json['user']['public_flags'],
      roles: RoleManager.fromList(serverRoles.value),
      isBot: json['user']['bot'] ?? false,
    );
  }

  @override
  Map<String, dynamic> deserialize(Member member) {
    final roles = member.roles.list.values
        .map((element) => _marshaller.serializers.role.deserialize(element))
        .toList();

    return {
      'nick': member.nickname,
      'user': {
        'id': member.id,
        'username': member.username,
        'discriminator': member.discriminator,
        'global_name': member.globalName,
        'avatar': member.avatar,
        'avatar_decoration': member.avatarDecoration?.skuId,
        'bot': member.isBot,
        'flags': member.flags,
        'public_flags': member.publicFlags,
      },
      'roles': roles,
      'premium_since': member.premiumSince?.toIso8601String(),
      'flags': member.flags,
    };
  }
}
