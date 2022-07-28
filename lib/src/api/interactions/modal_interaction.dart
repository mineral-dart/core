import 'dart:core';

import 'package:mineral/api.dart';

class ModalInteraction extends Interaction {
  Message? _message;
  Snowflake _customId;

  Map<String, dynamic> data = {};

  ModalInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    super._member,
    this._customId,
  );

  Message? get message => _message;
  Snowflake get customId => _customId;

  /// ### Return an [String] if the modal has the designed field
  ///
  /// Example :
  /// ```dart
  /// String? field = interaction.getText('custom_field_id');
  /// ```
  String? getText(String customId) => data.get(customId);

  factory ModalInteraction.from({ required User user, required Message? message, required Guild guild, required dynamic payload }) {
    return ModalInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      InteractionType.modalSubmit,
      payload['token'],
      user,
      guild,
      guild.members.cache.getOrFail(user.id),
      payload['data']['custom_id']
    );
  }
}
