import 'dart:core';

import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class SelectMenuInteraction extends Interaction {
  Snowflake _customId;
  PartialChannel _channel;

  SelectMenuInteraction(
    super._id,
    super._label,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    super._message,
    this._customId,
    this._channel,
  );

  Snowflake get customId => _customId;

  PartialChannel get channel => _channel;

  factory SelectMenuInteraction.from({ required dynamic payload, required PartialChannel channel }) {
    return SelectMenuInteraction(
      payload['id'],
      null,
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'],
      payload['guild_id'],
      (payload['guild_id'] != null ? Message.from(channel: channel as GuildChannel, payload: payload['message']) : DmMessage.from(channel: channel as DmChannel, payload: payload['message'])) as PartialMessage<PartialChannel>?,
      payload['data']['custom_id'],
      channel,
    );
  }
}
