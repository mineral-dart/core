import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/interaction/command/global_command_context.dart';
import 'package:mineral/infrastructure/interaction/command/global_command_context.dart';
import 'package:mineral/infrastructure/interaction/command/global_command_context.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/infrastructure/commons/utils.dart';

final class GlobalCommandContextSerializer implements SerializerContract<GlobalCommandContext> {
  final MarshallerContract marshaller;

  GlobalCommandContextSerializer(this.marshaller);

  @override
  Future<GlobalCommandContext> serialize(Map<String, dynamic> json) async {
    return GlobalCommandContext(
      id: Snowflake(json['id']),
      applicationId: Snowflake(json['application_id']),
      version: json['version'],
      token: json['token'],
      channel: await marshaller.serializers.channels.serialize(json['channel']),
      user: await marshaller.serializers.user.serialize(json['user']),
    );
  }

  @override
  Map<String, dynamic> deserialize(GlobalCommandContext permission) {
    return {};
  }
}
