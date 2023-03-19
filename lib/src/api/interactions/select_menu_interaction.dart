import 'dart:core';

import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_ioc/ioc.dart';

class SelectMenuInteraction extends Interaction {
  Snowflake? _messageId;
  Snowflake _customId;
  Snowflake _channelId;

  final List<String> data = [];

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

  PartialMessage? get message => guild != null
    ? (guild?.channels.cache.get(_channelId) as dynamic)?.messages.cache[_messageId]
    : ioc.use<MineralClient>().dmChannels.cache.get(_channelId)?.messages.cache.getOrFail(_messageId);
  Snowflake get customId => _customId;
  PartialChannel? get channel => guild != null
      ? guild?.channels.cache.get(_channelId)
      : ioc.use<MineralClient>().dmChannels.cache.get(_channelId);

  /// ### Return an [List] of [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// List<String>? fields = interaction.getValues<String>();
  /// List<int>? fields = interaction.getValues<int>();
  /// ```
  List<T> getValues<T> () => data as List<T>;

  /// ### Return the first [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// String? field = interaction.getValue<String>();
  /// int? field = interaction.getValue<int>();
  /// ```
  T getValue<T> () => data.first as T;

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
