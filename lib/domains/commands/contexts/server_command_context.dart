import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/commands/command_context.dart';
import 'package:mineral/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_contract.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class ServerCommandContext implements CommandContext {
  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  final Member member;
  final Channel? channel;
  final Server server;
  late final InteractionContract interaction;

  ServerCommandContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.member,
    required this.server,
    this.channel,
  }) {
    interaction = Interaction(token, id);
  }

  static Future<ServerCommandContext> fromMap(
      MarshallerContract marshaller, Map<String, dynamic> payload) async {
    return ServerCommandContext(
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      member: await marshaller.dataStore.member.getMember(
        serverId: Snowflake(payload['guild_id']),
        memberId: Snowflake(payload['member']['user']['id']),
      ),
      server: await marshaller.dataStore.server.getServer(Snowflake(payload['guild_id'])),
      channel: await marshaller.dataStore.channel.getChannel(Snowflake(payload['channel_id'])),
    );
  }
}
