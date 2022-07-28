import 'package:mineral/api.dart';

class ContextMessageInteraction extends Interaction {
  Message _message;
  Channel _channel;

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
  Channel get channel => _channel;

  factory ContextMessageInteraction.from({ required User user, required Guild guild, required Message message, required dynamic payload }) {
    return ContextMessageInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      InteractionType.values.firstWhere((element) => element.value == payload['type']),
      payload['token'],
      user,
      guild,
      guild.members.cache.get(user.id),
      message,
      message.channel,
    );
  }
}
