import 'dart:core';

import 'package:mineral/api.dart';

class SelectMenuInteraction extends Interaction {
  Message? _message;
  Snowflake _customId;

  final List<String> data = [];

  SelectMenuInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    super._member,
    this._message,
    this._customId,
  );

  Message? get message => _message;
  Snowflake get customId => _customId;

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

  factory SelectMenuInteraction.from({ required User user, required Message? message, required Guild? guild, required dynamic payload }) {
    return SelectMenuInteraction(
        payload['id'],
        payload['application_id'],
        payload['version'],
        InteractionType.messageComponent,
        payload['token'],
        user,
        guild,
        guild?.members.cache.get(user.id),
        message,
        payload['data']['custom_id'],
    );
  }
}
