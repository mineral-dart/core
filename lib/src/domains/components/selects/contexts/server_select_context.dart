import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/domains/components/selects/button_context.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class ServerSelectContext implements SelectContext {
  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  @override
  final String customId;

  final Member member;

  final ServerMessage message;

  late final InteractionContract interaction;

  ServerSelectContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.message,
    required this.member,
  }) {
    interaction = Interaction(token, id);
  }

  static Future<ServerSelectContext> fromMap(
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    return ServerSelectContext(
      customId: payload['data']['custom_id'],
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      message: await datastore.message.getServerMessage(
        messageId: Snowflake(payload['message']['id']),
        channelId: Snowflake(payload['channel_id']),
      ),
      member: await datastore.member.getMember(
        serverId: Snowflake(payload['guild_id']),
        memberId: Snowflake(payload['member']['user']['id']),
      ),
    );
  }
}
