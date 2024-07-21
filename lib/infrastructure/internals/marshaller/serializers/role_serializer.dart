import 'package:mineral/api/common/color.dart';
import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/infrastructure/commons/utils.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class RoleSerializer implements SerializerContract<Role> {
  final MarshallerContract marshaller;

  RoleSerializer(this.marshaller);

  @override
  Future<Role> serializeRemote(Map<String, dynamic> json) async => _serialize(json);

  @override
  Future<Role> serializeCache(Map<String, dynamic> json) async => _serialize(json);

  Role _serialize(Map<String, dynamic> payload) {
    return Role(
      id: Snowflake(payload['id']),
      name: payload['name'],
      color: Color.of(payload['color'] ?? 0),
      hoist: payload['hoist'] ?? false,
      position: payload['position'] ?? 0,
      permissions: switch(payload['permissions']) {
        int() => Permissions.fromInt(payload['permissions']),
        String() => Permissions.fromInt(int.parse(payload['permissions'])),
        _ => Permissions.fromInt(0),
      },
      managed: payload['managed'],
      mentionable: payload['mentionable'],
      flags: payload['flags'],
      icon: payload['icon'],
      unicodeEmoji: payload['unicode_emoji'],
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
