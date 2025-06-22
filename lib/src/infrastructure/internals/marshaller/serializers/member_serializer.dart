import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/permissions.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class MemberSerializer implements SerializerContract<Member> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['user']['id'],
      'username': json['user']['username'],
      'nickname': json['nick'],
      'global_name': json['user']['global_name'],
      'discriminator': json['user']['discriminator'],
      'assets': {
        'server_id': json['guild_id'],
        'member_id': json['user']['id'],
        'avatar': json['user']['avatar'],
        'avatar_decoration': json['user']['avatar_decoration_data']?['sku_id'],
        'banner': json['banner'],
      },
      'flags': json['flags'],
      'roles': List.from(json['roles']),
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
      'server_id': json['guild_id'],
    };

    final cacheKey =
        _marshaller.cacheKey.member(json['guild_id'], json['user']['id']);
    await _marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<Member> serialize(Map<String, dynamic> json) async {
    final assets = Map<String, dynamic>.from(json['assets']);
    final memberAsset = MemberAssets(
      avatar: Helper.createOrNull(
          field: assets['avatar'],
          fn: () => ImageAsset(['avatars', assets['member_id'].toString()],
              assets['avatar'].toString())),
      avatarDecoration: Helper.createOrNull(
          field: assets['avatar_decoration'],
          fn: () => ImageAsset(
              ['avatar-decorations', assets['member_id'].toString()],
              assets['avatar_decoration'].toString())),
      banner: Helper.createOrNull(
          field: assets['banner'],
          fn: () =>
              ImageAsset(['banners', assets['member_id']], assets['banner'])),
    );

    final memberRoleManager = MemberRoleManager(
        List.from(json['roles']).map(Snowflake.parse).toList(),
        Snowflake.parse(json['server_id']),
        Snowflake.parse(json['id']));

    return Member(
      id: Snowflake.parse(json['id']),
      serverId: Snowflake.parse(json['server_id']),
      username: json['nick'] ?? json['username'],
      nickname: json['nick'] ?? json['display_name'],
      globalName: json['global_name'],
      discriminator: json['discriminator'],
      assets: memberAsset,
      flags:
          MemberFlagsManager(bitfieldToList(MemberFlag.values, json['flags'])),
      premiumSince: Helper.createOrNull(
          field: json['premium_since'],
          fn: () => DateTime.parse(json['premium_since'])),
      publicFlags: json['public_flags'],
      roles: memberRoleManager,
      isBot: json['is_bot'] ?? false,
      isPending: json['is_pending'] ?? false,
      timeout: MemberTimeout(
          duration: Helper.createOrNull(
              field: json['communication_disabled_until'],
              fn: () => DateTime.parse(json['communication_disabled_until']))),
      mfaEnabled: json['mfa_enabled'] ?? false,
      locale: json['locale'],
      premiumType: PremiumTier.values.firstWhere(
          (e) => e == json['premium_type'],
          orElse: () => PremiumTier.none),
      joinedAt: Helper.createOrNull(
          field: json['joined_at'],
          fn: () => DateTime.parse(json['joined_at'])),
      permissions: switch (json['permissions']) {
        int() => Permissions.fromInt(json['permissions']),
        String() => Permissions.fromInt(int.parse(json['permissions'])),
        _ => Permissions.fromInt(0),
      },
      accentColor: json['accent_color'],
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(Member member) async {
    return {
      'id': member.id.value,
      'username': member.username,
      'nickname': member.nickname,
      'global_name': member.globalName,
      'discriminator': member.discriminator,
      'assets': {
        'avatar': member.assets.avatar?.hash,
        'avatar_decoration': member.assets.avatarDecoration?.hash,
        'banner': member.assets.banner?.hash,
      },
      'roles': member.roles.currentIds.map((e) => e.value).toList(),
      'flags': listToBitfield(member.flags.list),
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
      'server_id': member.serverId.value,
    };
  }
}
