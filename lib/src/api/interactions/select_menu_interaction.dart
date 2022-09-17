import 'dart:core';

import 'package:mineral/api.dart';

class SelectMenuInteraction extends Interaction {
  Message? _message;
  Snowflake _customId;
  Snowflake _channelId;

  final List<String> data = [];

  SelectMenuInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    this._message,
    this._customId,
    this._channelId,
  );

  Message? get message => _message;
  Snowflake get customId => _customId;
  TextBasedChannel? get channel => guild?.channels.cache.get(_channelId);

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

  factory SelectMenuInteraction.from({ required Message? message, required dynamic payload }) {
    return SelectMenuInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'],
      payload['guild_id'],
      message,
      payload['data']['custom_id'],
      payload['channel_id'],
    );
  }
}
