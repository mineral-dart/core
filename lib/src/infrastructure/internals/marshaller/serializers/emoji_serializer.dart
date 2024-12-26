import 'dart:async';

import 'package:mineral/src/api/common/emoji.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class EmojiSerializer implements SerializerContract<Emoji> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'name': json['name'],
      'managed': json['managed'] ?? false,
      'available': json['available'] ?? false,
      'animated': json['animated'] ?? false,
      'roles': json['roles'] != null
          ? List.from(json['roles'])
              .map((element) => _marshaller.cacheKey.serverEmoji(json['guild_id'], element['id']))
              .toList()
          : <String>[]
    };

    final cacheKey = _marshaller.cacheKey.serverEmoji(json['guild_id'], json['id']);
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
