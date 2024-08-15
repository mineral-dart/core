import 'dart:async';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/domains/commands/contexts/global_command_context.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class GlobalCommandContextSerializer implements SerializerContract<GlobalCommandContext> {
  final MarshallerContract marshaller;

  GlobalCommandContextSerializer(this.marshaller);

  @override
  Future<GlobalCommandContext> serializeRemote(Map<String, dynamic> json) async {
    return GlobalCommandContext(
      id: Snowflake(json['id']),
      applicationId: Snowflake(json['application_id']),
      version: json['version'],
      token: json['token'],
      channel: await marshaller.serializers.channels.serializeRemote(json['channel']),
      user: await marshaller.serializers.user.serializeRemote(json['user']),
    );
  }

  @override
  Future<GlobalCommandContext> serializeCache(Map<String, dynamic> json) async {
    return GlobalCommandContext(
      id: Snowflake(json['id']),
      applicationId: Snowflake(json['application_id']),
      version: json['version'],
      token: json['token'],
      channel: await marshaller.serializers.channels.serializeCache(json['channel']),
      user: await marshaller.serializers.user.serializeCache(json['user']),
    );
  }

  @override
  Map<String, dynamic> deserialize(GlobalCommandContext permission) {
    return {};
  }
}
