import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/commands/command_context.dart';

final class ServerCommandContext extends CommandContext {
  final Member member;
  final Server server;

  ServerCommandContext({
    required super.id,
    required super.applicationId,
    required super.token,
    required super.version,
    required this.member,
    required this.server,
    super.channel,
  });

  static Future<ServerCommandContext> fromMap(MarshallerContract marshaller,
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    final memberMap = payload['member'] as Map<String, dynamic>;
    final memberUser = memberMap['user'] as Map<String, dynamic>;
    final member = await datastore.member.get(
      payload['guild_id'] as String,
      memberUser['id'] as String,
      false,
    );

    return ServerCommandContext(
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'] as String,
      version: payload['version'] as int,
      member: member!,
      server: await datastore.server.get(payload['guild_id'] as String, true),
      channel: await datastore.channel.get(payload['channel_id'] as String, false),
    );
  }
}
