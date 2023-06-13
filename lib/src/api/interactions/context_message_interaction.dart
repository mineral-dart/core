import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/context_menu_interaction.dart';

class ContextMessageInteraction extends ContextMenuInteraction {
  Snowflake _channelId;
  Message _message;

  ContextMessageInteraction(
    this._channelId,
    this._message,
    super._type,
    super._id,
    super._label,
    super._applicationId,
    super._version,
    super._typeId,
    super._token,
    super._userId,
    super._guildId,
  );

  /// Get message [Message] of this
  Message get message => _message;
  /// Get channel [TextBasedChannel] of this
  TextBasedChannel get channel => guild!.channels.cache.get(_channelId)!;

  factory ContextMessageInteraction.from({ required Message message, required dynamic payload }) {
    return ContextMessageInteraction(
      payload['channel_id'],
      message,
      payload['type'],
      payload['id'],
      payload['data']['name'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'] ?? payload['user']?['id'],
      payload['guild_id'],
    );
  }
}
