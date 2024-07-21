import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class EmojiSerializer implements SerializerContract<Emoji> {
  final MarshallerContract _marshaller;

  EmojiSerializer(this._marshaller);

  @override
  Emoji serializeRemote(Map<String, dynamic> json) {
    final guildRoles = List<Role>.from(json['guildRoles']);

    final Map<Snowflake, Role> roles = List<String>.from(json['roles']).fold({}, (value, element) {
      final role = guildRoles.firstWhereOrNull((role) => role.id.value == element);

      if (role == null) {
        // Todo add report case
        return value;
      }

      return {...value, role.id: role};
    });

    return Emoji(
      id: json['id'],
      name: json['name'],
      globalName: json['global_name'],
      roles: roles,
      managed: json['managed'],
      animated: json['animated'],
      available: json['available'],
    );
  }

  @override
  Future<Emoji> serializeCache(Map<String, dynamic> json) async {
    final roles = await List.from(json['roles']).map((id) async {
      final rawRole = await _marshaller.cache.getOrFail('server-${json['serverId']}/role-$id');
      return _marshaller.serializers.role.serializeCache(rawRole);
    }).wait;

    return Emoji(
      id: json['id'],
      name: json['name'],
      globalName: json['global_name'],
      roles: roles.fold({}, (value, element) => {...value, element.id: element}),
      managed: json['managed'],
      animated: json['animated'],
      available: json['available'],
    );
  }

  @override
  Map<String, dynamic> deserialize(Emoji emoji) {
    return {
      'id': emoji.id,
      'name': emoji.name,
      'roles': emoji.roles.keys.toList(),
      'managed': emoji.managed,
      'animated': emoji.animated,
      'available': emoji.available,
    };
  }
}
