import 'dart:core';

import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ModalInteraction extends Interaction {
  Snowflake _customId;
  Snowflake _channelId;

  Map<String, dynamic> data = {};

  ModalInteraction(
    super._id,
    super._label,
    super._applicationId,
    super._version,
    super._typeId,
    super._token,
    super._userId,
    super._guildId,
    this._customId,
    this._channelId,
  );

  Snowflake get customId => _customId;
  TextChannel? get channel => guild?.channels.cache.get(_channelId);

  /// ### Return an [String] if the modal has the designed field
  ///
  /// Example :
  /// ```dart
  /// String? field = interaction.getText('custom_field_id');
  /// ```
  String? getText(String customId) => data.get(customId);

  factory ModalInteraction.from({ required dynamic payload }) {
    return ModalInteraction(
      payload['id'],
      null,
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'],
      payload['guild_id'],
      payload['data']['custom_id'],
      payload['channel_id'],
    );
  }
}
