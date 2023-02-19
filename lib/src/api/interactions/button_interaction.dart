import 'dart:core';

import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_ioc/ioc.dart';

class ButtonInteraction extends Interaction {
  Snowflake _customId;
  Snowflake? _messageId;
  Snowflake _channelId;

  ButtonInteraction(
    super._id,
    super._label,
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
  PartialMessage? get message => guild != null
    ? (guild?.channels.cache.get(_channelId) as dynamic)?.messages.cache[_messageId]
    : ioc.use<MineralClient>().dmChannels.cache.get(_channelId)?.messages.cache.getOrFail(_messageId);
  PartialChannel get channel => guild != null
    ? guild!.channels.cache.getOrFail<TextBasedChannel>(_channelId)
    : throw UnsupportedError('DM channel is not supported');

  factory ButtonInteraction.fromPayload(dynamic payload) {
    return ButtonInteraction(
      payload['id'],
      null,
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
