import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/domains/components/dialog/dialog_context.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class ServerDialogContext implements DialogContext {
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

  late final InteractionContract interaction;

  ServerDialogContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.member,
  }) {
    interaction = Interaction(token, id);
  }

  static Future<ServerDialogContext> fromMap(
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    return ServerDialogContext(
      customId: payload['data']['custom_id'],
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      member: await datastore.member.get(
        payload['guild_id'],
        payload['member']['user']['id'],
        false,
      ),
    );
  }
}
