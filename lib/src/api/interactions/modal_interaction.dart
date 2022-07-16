import 'dart:core';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/interactions/interaction.dart';

class ModalInteraction extends Interaction {
  Message? message;
  Snowflake customId;
  Map<String, dynamic> data = {};

  ModalInteraction({
    required this.message,
    required this.customId,
    required InteractionType type,
    required Snowflake applicationId,
    required Snowflake id,
    required int version,
    required String token,
    required User user
  }) : super(id: id, version: version, token: token, type: type, user: user, applicationId: applicationId);

  /// ### Return an [String] if the modal has the designed field
  /// ```dart
  /// String? field = interaction.getText('custom_field_id');
  /// ```
  String? getText(String customId) => data.get(customId);

  factory ModalInteraction.from({ required User user, required Message? message, required dynamic payload }) {
    return ModalInteraction(
      id: payload['id'],
      applicationId: payload['application_id'],
      type: InteractionType.modalSubmit,
      version: payload['version'],
      token: payload['token'],
      user: user,
      message: message,
      customId: payload['data']['custom_id']
    );
  }
}
