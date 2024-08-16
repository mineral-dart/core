import 'dart:async';

import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class EmojiSerializer implements SerializerContract<Emoji> {
  final MarshallerContract _marshaller;

  EmojiSerializer(this._marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'name': json['name'],
      'managed': json['managed'] ?? false,
      'available': json['available'] ?? false,
      'animated': json['animated'] ?? false,
      'roles': List.from(json['roles'])
          .map((element) => _marshaller.cacheKey.serverEmoji(json['server_id'], element['id']))
          .toList(),
    };

    final cacheKey = _marshaller.cacheKey.serverEmoji(json['server_id'], json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<Emoji> serialize(Map<String, dynamic> json) async {
    final rawRoles = await _marshaller.cache.getMany(json['roles']);
    final roles = await rawRoles.nonNulls.map((element) async {
      return _marshaller.serializers.role.serialize(element);
    }).wait;

    return Emoji(
      id: json['id'],
      name: json['name'],
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
