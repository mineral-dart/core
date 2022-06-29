import 'dart:core';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/interactions/interaction.dart';

class SelectMenuInteraction extends Interaction {
  Message? message;
  Snowflake customId;
  List<String> data = [];

  SelectMenuInteraction({
    required this.message,
    required this.customId,
    required InteractionType type,
    required Snowflake applicationId,
    required Snowflake id,
    required int version,
    required String token,
    required User user
  }) : super(id: id, version: version, token: token, type: type, user: user, applicationId: applicationId);

  List<T> getValues<T> () => data as List<T>;

  T getValue<T> () => data.first as T;

  factory SelectMenuInteraction.from({ required User user, required Message? message, required dynamic payload }) {
    return SelectMenuInteraction(
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
