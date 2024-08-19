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
      isPending: json['is_pending'] ?? false,
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
      // TODO : presence
      presence: null,
    );

    member.roles.member = member;
    member.flags.member = member;

    return member;
  }

  @override
  Future<Map<String, dynamic>> deserialize(Member member) async {
    final rawAsset = await _marshaller.serializers.memberAssets.deserialize(member.assets);
    final rawRoles = await member.roles.list.entries.map((role) async {
      final cacheKey = _marshaller.cacheKey.serverRole(member.server.id, role.key);
      return {cacheKey: await _marshaller.serializers.role.deserialize(role.value)};
    }).wait;

    await _marshaller.cache.putMany({
      _marshaller.cacheKey.memberAssets(member.server.id, member.id): rawAsset,
      ...rawRoles.fold({}, (prev, element) => {...prev, ...element}),
    });

    return {
      'id': member.id,
      'username': member.username,
      'nickname': member.nickname,
      'global_name': member.globalName,
      'discriminator': member.discriminator,
      'assets': _marshaller.cacheKey.memberAssets(member.server.id, member.id),
      'flags': listToBitfield(member.flags.list),
      'roles': member.roles.list.keys
          .map((id) => _marshaller.cacheKey.serverRole(member.server.id, id))
          .toList(),
      'premium_since': member.premiumSince?.toIso8601String(),
      'public_flags': member.publicFlags,
      'is_bot': member.isBot,
      'is_pending': member.isPending,
      'timeout': member.timeout.duration?.toIso8601String(),
      'mfa_enabled': member.mfaEnabled,
      'locale': member.locale,
      'premium_type': member.premiumType.value,
      'joined_at': member.joinedAt?.toIso8601String(),
      'permissions': listToBitfield(member.permissions.list),
      'accent_color': member.accentColor,
      // TODO : presence
    };
  }
}
