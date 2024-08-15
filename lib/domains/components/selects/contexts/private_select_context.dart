import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/components/selects/button_context.dart';
import 'package:mineral/infrastructure/internals/interactions/interaction.dart';
import 'package:mineral/infrastructure/internals/interactions/types/interaction_contract.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

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

  static Future<PrivateSelectContext> fromMap(MarshallerContract marshaller, Map<String, dynamic> payload) async{
    return PrivateSelectContext(
      customId: payload['data']['custom_id'],
      id: Snowflake(payload['id']),
      applicationId: Snowflake(payload['application_id']),
      token: payload['token'],
      version: payload['version'],
      message: await marshaller.dataStore.message.getPrivateMessage(
        messageId: Snowflake(payload['message']['id']),
        channelId: Snowflake(payload['channel_id']),
      ),
      user: await marshaller.serializers.user.serializeRemote(payload['user']),
    );
  }
}
