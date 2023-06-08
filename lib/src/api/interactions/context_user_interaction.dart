import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/context_menu_interaction.dart';

class ContextUserInteraction extends ContextMenuInteraction {
  Snowflake? _targetId;
  Snowflake? _channelId;

  ContextUserInteraction(
    this._targetId,
    this._channelId,
    super._type,
    super._id,
    super._label,
    super._applicationId,
    super._version,
    super._typeId,
    super._token,
    super._user,
    super._guild,
  );

  /// Get target [GuildMember] of this
  GuildMember? get target => guild?.members.cache.get(_targetId);
  /// Get channel [GuildChannel] of this
  GuildChannel? get channel => guild?.channels.cache.get(_channelId);

  factory ContextUserInteraction.from({ required dynamic payload }) {
    return ContextUserInteraction(
      payload['target_id'],
      payload['channel_id'],
      payload['type'],
      payload['id'],
      payload['name'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'],
      payload['guild_id'],
    );
  }
}
