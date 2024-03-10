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
        int() => json['permissions'],
        String() => int.parse(json['permissions']),
        _ => null,
      },
      managed: json['managed'],
      mentionable: json['mentionable'],
      flags: json['flags'],
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
