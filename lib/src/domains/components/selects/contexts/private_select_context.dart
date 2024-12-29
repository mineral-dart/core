import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class PrivateSelectContext implements SelectContext {
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

  final PrivateMessage message;

  late final InteractionContract interaction;

  PrivateSelectContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.message,
    required this.user,
  }) {
    interaction = Interaction(token, id);
  }

  static Future<PrivateSelectContext> fromMap(MarshallerContract marshaller,
      DataStoreContract datastore, Map<String, dynamic> payload) async {
    return PrivateSelectContext(
      customId: payload['data']['custom_id'],
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      message: (await datastore.message.get<PrivateMessage>(
        payload['channel_id'],
        payload['message']['id'],
        false,
      ))!,
      user: await marshaller.serializers.user.serialize(payload['user']),
    );
  }
}
