import 'package:mineral/api.dart';

class ContextMessageInteraction extends Interaction {
  Snowflake _channelId;
  Message _message;

  ContextMessageInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._typeId,
    super._token,
    super._userId,
    super._guildId,
    this._channelId,
    this._message,
  );

  Message get message => _message;
  TextBasedChannel get channel => guild!.channels.cache.get(_channelId)!;

  factory ContextMessageInteraction.from({ required Message message, required dynamic payload }) {
    return ContextMessageInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['user']?['id'],
      payload['guild_id'],
      payload['guild_id'],
      message,
    );
  }
}
