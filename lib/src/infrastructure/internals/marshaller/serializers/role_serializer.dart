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

    final cacheKey = _marshaller.cacheKey.serverRole(json['guild_id'], json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<Role> serialize(Map<String, dynamic> json) async => Role(
    id: Snowflake(json['id']),
    name: json['name'],
    color: Color.of(json['color'] ?? 0),
    hoist: json['hoist'] ?? false,
    position: json['position'] ?? 0,
    permissions: switch (json['permissions']) {
      int() => Permissions.fromInt(json['permissions']),
      String() => Permissions.fromInt(int.parse(json['permissions'])),
      _ => Permissions.fromInt(0),
    },
    managed: json['managed'],
    mentionable: json['mentionable'],
    flags: json['flags'],
    icon: json['icon'],
    unicodeEmoji: json['unicode_emoji'],
    serverId: Snowflake(json['server_id']),
  );

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
