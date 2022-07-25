import 'package:mineral/api.dart';

class ContextUserInteraction extends Interaction {
  GuildMember? _target;
  Channel? _channel;

  ContextUserInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    super._member,
    this._target,
    this._channel,
  );

  GuildMember? get target => _target;
  Channel? get channel => _channel;

  factory ContextUserInteraction.from({ required GuildMember? target, required Guild guild, required User user, required dynamic payload }) {
    return ContextUserInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      InteractionType.values.firstWhere((element) => element.value == payload['type']),
      payload['token'],
      user,
      guild,
      guild.members.cache.get(user.id),
      target,
      guild.channels.cache.getOrFail('channel_id')
    );
  }
}
