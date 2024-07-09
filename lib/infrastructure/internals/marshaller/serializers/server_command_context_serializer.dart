import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/interaction/command/global_command_context.dart';
import 'package:mineral/infrastructure/interaction/command/global_command_context.dart';
import 'package:mineral/infrastructure/interaction/command/global_command_context.dart';
import 'package:mineral/infrastructure/interaction/command/guild_command_context.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/infrastructure/commons/utils.dart';

final class ServerCommandContextSerializer implements SerializerContract<ServerCommandContext> {
  final MarshallerContract marshaller;

  ServerCommandContextSerializer(this.marshaller);

  @override
  Future<ServerCommandContext> serialize(Map<String, dynamic> json) async {
    return ServerCommandContext(
      id: Snowflake(json['id']),
      applicationId: Snowflake(json['application_id']),
      version: json['version'],
      token: json['token'],
      channel: await marshaller.serializers.channels.serialize(json['channel']),
      user: await marshaller.serializers.user.serialize(json['member']['user']),
      server: await marshaller.dataStore.server.getServer(json['guild_id']),
    );
  }

  @override
  Map<String, dynamic> deserialize(ServerCommandContext permission) {
    return {};
  }
}
