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
  Message? get message => guild?.channels.cache.get<TextBasedChannel>(_channelId)?.messages.cache.get(_messageId);
  TextBasedChannel? get channel => guild?.channels.cache.get<TextBasedChannel>(_channelId)?.messages.cache.get(_messageId);

  factory ButtonInteraction.fromPayload(dynamic payload) {
    return ButtonInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'],
      payload['guild_id'],
      payload['message_id'],
      payload['data']['custom_id'],
      payload['channel_id'],
    );
  }
}
