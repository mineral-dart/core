import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/commands/command_context.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/src/infrastructure/internals/interactions/types/interaction_contract.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';

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

  static Future<ServerCommandContext> fromMap(MarshallerContract marshaller,
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    return ServerCommandContext(
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      member: await datastore.member.getMember(
        serverId: Snowflake(payload['guild_id']),
        memberId: Snowflake(payload['member']['user']['id']),
      ),
      server: await datastore.server.getServer(Snowflake(payload['guild_id'])),
      channel: await datastore.channel.getChannel(Snowflake(payload['channel_id'])),
    );
  }
}
