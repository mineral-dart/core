import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/components/modal/modal_context.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class PrivateModalContext implements ModalContext {
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

  PrivateModalContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.user,
  }) {
    interaction = Interaction(token, id);
  }

  static Future<PrivateModalContext> fromMap(
    MarshallerContract marshaller,
    Map<String, dynamic> payload,
  ) async {
    return PrivateModalContext(
      customId: payload['data']['custom_id'],
      id: Snowflake.parse(payload['id']),
      applicationId: Snowflake.parse(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      user: await marshaller.serializers.user.serialize(payload['user']),
    );
  }
}
