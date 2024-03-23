import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';
import 'package:mineral/domains/shared/utils.dart';

final class ChannelPermissionOverwriteSerializer implements SerializerContract<ChannelPermissionOverwrite> {
  final MarshallerContract marshaller;

  ChannelPermissionOverwriteSerializer(this.marshaller);

  @override
  ChannelPermissionOverwrite serialize(Map<String, dynamic> json, {bool cache = false}) {
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
      'allow_new': permission.allow,
      'deny_new': permission.deny,
    };
  }
}
