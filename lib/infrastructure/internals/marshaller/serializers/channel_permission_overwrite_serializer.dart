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
  ChannelPermissionOverwrite serializeRemote(Map<String, dynamic> json) => _serialize(json);

  @override
  ChannelPermissionOverwrite serializeCache(Map<String, dynamic> json) => _serialize(json);

  ChannelPermissionOverwrite _serialize(Map<String, dynamic> payload) {
    return ChannelPermissionOverwrite(
      id: Snowflake(payload['id']),
      type: findInEnum(ChannelPermissionOverwriteType.values, payload['type']),
      allow: payload['allow'],
      deny: payload['deny'],
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
