import 'dart:core';

import 'package:mineral/api.dart';

class ButtonInteraction extends Interaction {
  Message? _message;
  Snowflake _customId;

  ButtonInteraction(
    super.id,
    super.applicationId,
    super.version,
    super.type,
    super.token,
    super.user,
    super.guild,
    super.member,
    this._message,
    this._customId,
  );

  Message? get message => _message;
  Snowflake get customId => _customId;

  factory ButtonInteraction.from({ required User user, required Guild guild, required Message message, required dynamic payload }) {
    return ButtonInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      InteractionType.messageComponent,
      payload['token'],
      user,
      guild,
      guild.members.cache.getOrFail(user.id),
      message,
      payload['data']['custom_id']
    );
  }
}
