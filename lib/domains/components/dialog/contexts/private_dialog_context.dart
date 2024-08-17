import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/components/dialog/dialog_context.dart';
import 'package:mineral/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_contract.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

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

  static Future<PrivateDialogContext> fromMap(MarshallerContract marshaller, Map<String, dynamic> payload) async{
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
