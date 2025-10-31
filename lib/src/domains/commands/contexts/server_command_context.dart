import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/commands/command_context.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class ServerCommandContext implements CommandContext {
  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  @override
  late final InteractionContract interaction;

  final Member member;
  final Channel? channel;
  final Server server;

  ServerCommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.member,
    required this.server,
    this.channel,
  }) : interaction = Interaction(token, id);

  static Future<ServerCommandContext> fromMap(
    MarshallerContract marshaller,
    DataStoreContract datastore,
    Map<String, dynamic> payload,
  ) async {
    final member = await datastore.member.get(
      payload['guild_id'],
      payload['member']['user']['id'],
      false,
    );

    return ServerCommandContext(
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      member: member!,
      server: await datastore.server.get(payload['guild_id'], true),
      channel: await datastore.channel.get(payload['channel_id'], false),
    );
  }
}
