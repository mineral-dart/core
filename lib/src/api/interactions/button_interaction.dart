import 'dart:core';

import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class ButtonInteraction extends Interaction {
  Snowflake _customId;
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
    super._message,
    this._customId,
    this._channelId,
  );

  /// Get custom id of this
  Snowflake get customId => _customId;

  /// Get channel [PartialChannel] of this
  PartialChannel get channel => guild != null
    ? guild!.channels.cache.getOrFail<TextBasedChannel>(_channelId)
    : throw UnsupportedError('DM channel is not supported');

  factory ButtonInteraction.fromPayload(PartialChannel channel, dynamic payload) {
    return ButtonInteraction(
      payload['id'],
      null,
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'] ?? payload['user']?['id'],
      payload['guild_id'],
      (payload['guild_id'] != null ? Message.from(channel: channel as GuildChannel, payload: payload['message']) : DmMessage.from(channel: channel as DmChannel, payload: payload['message'])) as PartialMessage<PartialChannel>?,
      payload['data']['custom_id'],
      payload['channel_id'],
    );
  }
}
