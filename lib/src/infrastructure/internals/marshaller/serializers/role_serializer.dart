import 'package:mineral/src/api/common/color.dart';
import 'package:mineral/src/api/common/permissions.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class RoleSerializer implements SerializerContract<Role> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'name': json['name'],
      'color': json['color'],
      'hoist': json['hoist'],
      'position': json['position'],
      'permissions': json['permissions'],
      'managed': json['managed'],
      'mentionable': json['mentionable'],
      'flags': json['flags'],
      'server_id': json['guild_id'],
    };

    final cacheKey =
        _marshaller.cacheKey.serverRole(json['guild_id'], json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<Role> serialize(Map<String, dynamic> json) async => _serialize(json);

  Role _serialize(Map<String, dynamic> payload) {
    return Role(
      id: Snowflake(payload['id']),
      name: payload['name'],
      color: Color.of(payload['color'] ?? 0),
      hoist: payload['hoist'] ?? false,
      position: payload['position'] ?? 0,
      permissions: switch (payload['permissions']) {
        int() => Permissions.fromInt(payload['permissions']),
        String() => Permissions.fromInt(int.parse(payload['permissions'])),
        _ => Permissions.fromInt(0),
      },
      managed: payload['managed'],
      mentionable: payload['mentionable'],
      flags: payload['flags'],
      icon: payload['icon'],
      unicodeEmoji: payload['unicode_emoji'],
      serverId: Snowflake(payload['server_id']),
    );
  }

  @override
  Map<String, dynamic> deserialize(Role object) {
    return {
      'id': object.id,
      'name': object.name,
      'color': object.color.toInt(),
      'hoist': object.hoist,
      'position': object.position,
      'permissions': listToBitfield(object.permissions.list),
      'managed': object.managed,
      'mentionable': object.mentionable,
      'flags': object.flags,
    };
  }
}
