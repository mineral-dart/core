import 'dart:core';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/interactions/interaction.dart';

class ButtonInteraction extends Interaction {
  Message? message;
  Snowflake customId;

  ButtonInteraction({
    required this.message,
    required this.customId,
    required InteractionType type,
    required Snowflake applicationId,
    required Snowflake id,
    required int version,
    required String token,
    required User user
  }) : super(id: id, version: version, token: token, type: type, user: user, applicationId: applicationId);

  factory ButtonInteraction.from({ required User user, required Message? message, required dynamic payload }) {
    return ButtonInteraction(
      id: payload['id'],
      applicationId: payload['application_id'],
      type: InteractionType.messageComponent,
      version: payload['version'],
      token: payload['token'],
      user: user,
      message: message,
      customId: payload['data']['custom_id']
    );
  }
}
