import 'dart:core';

import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_ioc/ioc.dart';

class SelectMenuInteraction extends Interaction {
  Snowflake? _messageId;
  Snowflake _customId;
  Snowflake _channelId;

  SelectMenuInteraction(
    super._id,
    super._label,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    this._messageId,
    this._customId,
    this._channelId,
  );

  PartialMessage get message => guild != null
    ? guild!.channels.cache.getOrFail(_channelId).cast<dynamic>().messages.cache[_messageId]
    : ioc.use<MineralClient>().dmChannels.cache.getOrFail(_channelId).messages.cache.getOrFail(_messageId);

  Snowflake get customId => _customId;

  PartialChannel get channel => guild != null
    ? guild!.channels.cache.getOrFail(_channelId)
    : ioc.use<MineralClient>().dmChannels.cache.getOrFail(_channelId);

  factory SelectMenuInteraction.from({ required dynamic payload }) {
    return SelectMenuInteraction(
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
