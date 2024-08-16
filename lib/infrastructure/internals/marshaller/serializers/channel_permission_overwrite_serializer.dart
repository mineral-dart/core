import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/commons/utils.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ChannelPermissionOverwriteSerializer
    implements SerializerContract<ChannelPermissionOverwrite> {
  final MarshallerContract marshaller;

  ChannelPermissionOverwriteSerializer(this.marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'type': json['type'],
      'allow': json['allow'],
      'deny': json['deny'],
    };

    final cacheKey = marshaller.cacheKey
        .channelPermission(Snowflake(payload['id']), serverId: json['server_id']);
    await marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  ChannelPermissionOverwrite serialize(Map<String, dynamic> json) {
    return ChannelPermissionOverwrite(
      id: Snowflake(json['id']),
      type: findInEnum(ChannelPermissionOverwriteType.values, json['type']),
      allow: json['allow'],
      deny: json['deny'],
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
