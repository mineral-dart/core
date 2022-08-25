import 'package:mineral/api.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class ContextMessageInteraction extends Interaction {
  Message _message;
  PartialChannel _channel;

  ContextMessageInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    super._member,
    this._message,
    this._channel,
  );

  Message get message => _message;
  PartialChannel get channel => _channel;

  factory ContextMessageInteraction.from({ required User user, required Guild guild, required PartialMessage message, required dynamic payload }) {
    return ContextMessageInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      InteractionType.values.firstWhere((element) => element.value == payload['type']),
      payload['token'],
      user,
      guild,
      guild.members.cache.get(user.id),
      message as Message,
      message.channel,
    );
  }
}
