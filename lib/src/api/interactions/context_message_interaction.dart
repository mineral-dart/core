import 'package:mineral/api.dart';

class ContextMessageInteraction extends Interaction {
  Message message;
  late Channel channel;

  ContextMessageInteraction({
    required this.message,
    required super.id,
    required super.applicationId,
    required super.version,
    required super.type,
    required super.token,
    required super.user
  });

  factory ContextMessageInteraction.from({ required User user, required Message message, required dynamic payload }) {
    return ContextMessageInteraction(
        message: message,
        id: payload['id'],
        applicationId: payload['application_id'],
        version: payload['version'],
        type: InteractionType.values.firstWhere((element) => element.value == payload['type']),
        token: payload['token'],
        user: user
    );
  }
}
