import 'package:mineral/api.dart';

class ContextUserInteraction extends Interaction {
  GuildMember? target;
  Channel? channel;

  ContextUserInteraction({
    required this.target,
    required super.id,
    required super.applicationId,
    required super.version,
    required super.type,
    required super.token,
    required super.user
  });

  factory ContextUserInteraction.from({ required GuildMember? target, required User user, required dynamic payload }) {
    return ContextUserInteraction(
        target: target,
        id: payload['id'],
        applicationId: payload['application_id'],
        version: payload['version'],
        type: InteractionType.values.firstWhere((element) => element.value == payload['type']),
        token: payload['token'],
        user: user
    );
  }
}
