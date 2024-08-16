import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/premium_tier.dart';
import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/server/enums/member_flag.dart';
import 'package:mineral/api/server/managers/member_role_manager.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/member_flags.dart';
import 'package:mineral/api/server/member_timeout.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/commons/utils.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class MemberSerializer implements SerializerContract<Member> {
  final MarshallerContract _marshaller;

  MemberSerializer(this._marshaller);

  @override
  Future<void> normalize(Map<String, dynamic> json) async {
    await _marshaller.serializers.memberAssets.normalize({
      ...json,
      'member_id': json['id'],
    });

    final payload = {
      'id': json['user']['id'],
      'username': json['user']['username'],
      'nickname': json['nick'],
      'global_name': json['user']['global_name'],
      'discriminator': json['user']['discriminator'],
      'assets': _marshaller.cacheKey.memberAssets(json['server_id'], json['user']['id']),
      'flags': json['flags'],
      'roles': List.from(json['roles'])
          .map((element) => _marshaller.cacheKey.serverRole(json['server_id_id'], element['id']))
          .toList(),
      'premium_since': json['premium_since'],
      'public_flags': json['user']['public_flags'],
      'is_bot': json['user']['bot'] ?? false,
      'is_pending': json['pending'] ?? false,
      'timeout': json['communication_disabled_until'],
      'mfa_enabled': json['user']['mfa_enabled'] ?? false,
      'locale': json['user']['locale'],
      'premium_type': json['user']['premium_type'],
      'joined_at': json['joined_at'],
      'permissions': json['permissions'],
      'pending': json['pending'] ?? false,
      'accent_color': json['accent_color'],
      // TODO : presence
    };

    final cacheKey = _marshaller.cacheKey.member(json['guild_id'], json['user']['id']);
    await _marshaller.cache.put(cacheKey, payload);
  }

  @override
  Future<Member> serialize(Map<String, dynamic> json) async {
    final rawAssets = await _marshaller.cache.getOrFail(json['assets']);
    final assets = await _marshaller.serializers.memberAssets.serialize(rawAssets);

    final rawRoles = await _marshaller.cache.getMany(json['roles']);
    final roles = await rawRoles.nonNulls.map((element) async {
      return _marshaller.serializers.role.serialize(element);
    }).wait;

    final member = Member(
      id: json['id'],
      username: json['nick'] ?? json['username'],
      nickname: json['nick'] ?? json['display_name'],
      globalName: json['global_name'],
      discriminator: json['discriminator'],
      assets: assets,
      flags: MemberFlagsManager(bitfieldToList(MemberFlag.values, json['flags'])),
      premiumSince: Helper.createOrNull(
          field: json['premium_since'], fn: () => DateTime.parse(json['premium_since'])),
      publicFlags: json['public_flags'],
      roles: MemberRoleManager.fromList(roles),
      isBot: json['is_bot'] ?? false,
      isPending: json['pending'] ?? false,
      timeout: MemberTimeout(
          duration: Helper.createOrNull(
              field: json['communication_disabled_until'],
              fn: () => DateTime.parse(json['communication_disabled_until']))),
      mfaEnabled: json['mfa_enabled'] ?? false,
      locale: json['locale'],
      premiumType: PremiumTier.values
          .firstWhere((e) => e == json['premium_type'], orElse: () => PremiumTier.none),
      joinedAt: Helper.createOrNull(
          field: json['joined_at'], fn: () => DateTime.parse(json['joined_at'])),
      permissions: switch (json['permissions']) {
        int() => Permissions.fromInt(json['permissions']),
        String() => Permissions.fromInt(int.parse(json['permissions'])),
        _ => Permissions.fromInt(0),
      },
      accentColor: json['accent_color'],
      presence: json['presence'] != null ? Presence.fromJson(json['presence']) : null,
    );

    member.roles.member = member;
    member.flags.member = member;

    return member;
  }

  @override
  Map<String, dynamic> deserialize(Member member) {
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
      'roles': member.roles.list.keys.toList(),
      'premium_since': member.premiumSince?.toIso8601String(),
      'flags': listToBitfield(member.flags.list),
      'pending': member.isPending,
      'communication_disabled_until': member.timeout.duration?.toIso8601String(),
    };
  }
}
