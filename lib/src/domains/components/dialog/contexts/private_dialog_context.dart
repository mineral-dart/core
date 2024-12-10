import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/components/dialog/dialog_context.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class PrivateDialogContext implements DialogContext {
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

  final User user;

  late final InteractionContract interaction;

  PrivateDialogContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.user,
  }) {
    interaction = Interaction(token, id);
  }

  static Future<PrivateDialogContext> fromMap(
      MarshallerContract marshaller, Map<String, dynamic> payload) async {
    return PrivateDialogContext(
      customId: payload['data']['custom_id'],
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      user: await marshaller.serializers.user.serialize(payload['user']),
    );
  }
}
