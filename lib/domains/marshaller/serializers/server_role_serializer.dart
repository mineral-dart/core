import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class RoleSerializer implements SerializerContract<Role> {
  final MarshallerContract marshaller;

  RoleSerializer(this.marshaller);

  @override
  Future<Role> serialize(Map<String, dynamic> json) async {
    return Role(
      id: Snowflake(json['id']),
      name: json['name'],
      color: json['color'],
      hoist: json['hoist'],
      position: json['position'],
      permissions: switch(json['permissions']) {
        int() => Permissions.fromInt(json['permissions']),
        String() => Permissions.fromInt(int.parse(json['permissions'])),
        _ => Permissions.fromInt(0),
      },
      managed: json['managed'],
      mentionable: json['mentionable'],
      flags: json['flags'],
      icon: json['icon'],
      unicodeEmoji: json['unicode_emoji'],
    );
  }

  @override
  Map<String, dynamic> deserialize(Role object) {
    return {
      'id': object.id,
      'name': object.name,
      'color': object.color,
      'hoist': object.hoist,
      'position': object.position,
      'permissions': object.permissions,
      'managed': object.managed,
      'mentionable': object.mentionable,
      'flags': object.flags,
    };
  }
}
