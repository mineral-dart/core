import 'package:mineral/api/common/color.dart';
import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/domains/shared/utils.dart';

final class RoleSerializer implements SerializerContract<Role> {
  final MarshallerContract marshaller;

  RoleSerializer(this.marshaller);

  @override
  Future<Role> serialize(Map<String, dynamic> json) async {
    return Role(
      id: Snowflake(json['id']),
      name: json['name'],
      color: Color.of(json['color'] ?? 0),
      hoist: json['hoist'] ?? false,
      position: json['position'] ?? 0,
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
