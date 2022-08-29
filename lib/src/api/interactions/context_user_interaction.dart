import 'package:mineral/api.dart';

class ContextUserInteraction extends Interaction {
  Snowflake? _targetId;
  Snowflake? _channelId;

  ContextUserInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    this._targetId,
    this._channelId,
  );

  GuildMember? get target => guild?.members.cache.get(_targetId);
  GuildChannel? get channel => guild?.channels.cache.get(_channelId);

  factory ContextUserInteraction.from({ required dynamic payload }) {
    return ContextUserInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['user']?['id'],
      payload['guild_id'],
      payload['target_id'],
      payload['channel_id']
    );
  }
}
