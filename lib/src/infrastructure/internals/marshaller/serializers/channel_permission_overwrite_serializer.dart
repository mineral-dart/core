import 'package:mineral/api.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class ChannelPermissionOverwriteSerializer
    implements SerializerContract<ChannelPermissionOverwrite> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'type': json['type'],
      'allow': json['allow'],
      'deny': json['deny'],
    };

    final cacheKey = _marshaller.cacheKey
        .channelPermission(payload['id'], serverId: json['server_id']);
    await _marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  ChannelPermissionOverwrite serialize(Map<String, dynamic> json) {
    return ChannelPermissionOverwrite(
      id: json['id'].toString(),
      type: findInEnum(ChannelPermissionOverwriteType.values, json['type']),
      allow: bitfieldToList(Permission.values, int.parse(json['allow'])),
      deny: bitfieldToList(Permission.values, int.parse(json['deny'])),
    );
  }

  @override
  Map<String, dynamic> deserialize(ChannelPermissionOverwrite permission) {
    return {
      'id': permission.id,
      'type': permission.type.value,
      'allow': permission.allow,
      'deny': permission.deny,
    };
  }
}
