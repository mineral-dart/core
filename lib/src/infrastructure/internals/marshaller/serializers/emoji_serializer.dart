import 'dart:async';

import 'package:mineral/src/api/common/emoji.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
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
              .map((element) => _marshaller.cacheKey
                  .serverEmoji(json['guild_id'], element['id']))
              .toList()
          : <String>[],
      'server_id': json['guild_id'],
    };

    final cacheKey =
        _marshaller.cacheKey.serverEmoji(json['guild_id'], json['id']);
    await _marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<Emoji> serialize(Map<String, dynamic> json) async {
    final rawRoles = await _marshaller.cache?.getMany(json['roles']);
    final roles = await rawRoles?.nonNulls.map((element) async {
      return _marshaller.serializers.role.serialize(element);
    }).wait;

    return Emoji(
      Snowflake.parse(json['server_id']),
      id: Snowflake.parse(json['id']),
      name: json['name'],
      roles: roles?.fold(
              {}, (value, element) => {...?value, element.id: element}) ??
          {},
      isManaged: json['managed'],
      isAnimated: json['animated'],
      isAvailable: json['available'],
    );
  }

  @override
  Map<String, dynamic> deserialize(Emoji emoji) {
    return {
      'id': emoji.id?.value,
      'name': emoji.name,
      'roles': emoji.roles.keys.toList(),
      'managed': emoji.isManaged,
      'animated': emoji.isAnimated,
      'available': emoji.isAvailable,
      'server_id': emoji.serverId.value,
    };
  }
}
