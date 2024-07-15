import 'dart:async';

import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/infrastructure/commons/utils.dart';

final class ChannelPermissionOverwriteSerializer implements SerializerContract<ChannelPermissionOverwrite> {
  final MarshallerContract marshaller;

  ChannelPermissionOverwriteSerializer(this.marshaller);

  @override
  ChannelPermissionOverwrite serializeRemote(Map<String, dynamic> json) {
    return ChannelPermissionOverwrite(
      id: Snowflake(json['id']),
      type: findInEnum(ChannelPermissionOverwriteType.values, json['type']),
      allow: json['allow'],
      deny: json['deny'],
    );
  }

  @override
  Future<ChannelPermissionOverwrite> serializeCache(Map<String, dynamic> json) {
    throw UnimplementedError();
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
