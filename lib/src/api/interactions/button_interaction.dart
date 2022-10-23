import 'dart:core';

import 'package:mineral/api.dart';

class ButtonInteraction extends Interaction {
  Snowflake _customId;
  Snowflake? _messageId;
  Snowflake _channelId;

  ButtonInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._typeId,
    super.token,
    super._userId,
    super._guildId,
    this._messageId,
    this._customId,
    this._channelId,
  );

  Snowflake get customId => _customId;
  Snowflake? get mid => _messageId;
  Message? get message => (guild?.channels.cache.get(_channelId) as dynamic)?.messages.cache[_messageId];
  GuildChannel? get channel => guild?.channels.cache.get<GuildChannel>(_channelId);

  factory ButtonInteraction.fromPayload(dynamic payload) {
    return ButtonInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'],
      payload['guild_id'],
      payload['message']?['id'],
      payload['data']['custom_id'],
      payload['channel_id'],
    );
  }
}
