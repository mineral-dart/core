import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/premium_tier.dart';
import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/server/enums/member_flag.dart';
import 'package:mineral/api/server/managers/member_role_manager.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/member_assets.dart';
import 'package:mineral/api/server/member_flags.dart';
import 'package:mineral/api/server/member_timeout.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/commons/utils.dart';

final class MemberSerializer implements SerializerContract<Member> {
  final MarshallerContract _marshaller;

  MemberSerializer(this._marshaller);

  @override
  Future<Member> serialize(Map<String, dynamic> json) async {
    final serverRoles = json.entries.firstWhere((element) => element.key == 'guild_roles',
        orElse: () => throw FormatException('Server roles not found in member structure'));

    final member = Member(
      id: json['user']['id'],
      username: json['user']['nick'] ?? json['user']['username'],
      nickname: json['nick'] ?? json['user']['display_name'],
      globalName: json['user']['global_name'],
      discriminator: json['user']['discriminator'],
      assets: MemberAssets.fromJson(json['user']),
      flags: MemberFlagsManager(bitfieldToList(MemberFlag.values, json['flags'])),
      premiumSince: Helper.createOrNull(
          field: json['premium_since'], fn: () => DateTime.parse(json['premium_since'])),
      publicFlags: json['user']['public_flags'],
      roles: MemberRoleManager.fromList(serverRoles.value),
      isBot: json['user']['bot'] ?? false,
      isPending: json['pending'] ?? false,
      timeout: MemberTimeout(
          duration: Helper.createOrNull(
              field: json['communication_disabled_until'],
              fn: () => DateTime.parse(json['communication_disabled_until']))),
      mfAEnabled: json['user']['mfa_enabled'] ?? false,
      locale: json['user']['locale'],
      premiumType: PremiumTier.values.firstWhere((e) => e == json['user']['premium_type'], orElse: () => PremiumTier.none),
      joinedAt: Helper.createOrNull(
          field: json['joined_at'], fn: () => DateTime.parse(json['joined_at'])),
      permissions: switch(json['permissions']) {
        int() => Permissions.fromInt(json['permissions']),
        String() => Permissions.fromInt(int.parse(json['permissions'])),
        _ => Permissions.fromInt(0),
      },
      pending: json['pending'] ?? false,
      accentColor: json['accent_color'],
      presence: json['presence'] != null ? Presence.fromJson(json['presence']) : null,
    );

    member.roles.member = member;
    member.flags.member = member;

    return member;
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
        'avatar': member.assets.avatar?.hash,
        'avatar_decoration': member.assets.avatarDecoration?.hash,
        'banner': member.assets.banner?.hash,
        'bot': member.isBot,
        'flags': listToBitfield(member.flags.list),
        'public_flags': member.publicFlags,
      },
      'roles': roles,
      'premium_since': member.premiumSince?.toIso8601String(),
      'flags': listToBitfield(member.flags.list),
      'pending': member.isPending,
      'communication_disabled_until': member.timeout.duration?.toIso8601String(),
    };
  }
}
