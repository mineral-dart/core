import 'package:mineral/api.dart';

enum InteractionCallbackType {
  pong(1),
  channelMessageWithSource(4),
  deferredChannelMessageWithSource(5),
  deferredUpdateMessage(6),
  updateMessage(7),
  applicationCommandAutocompleteResult(8),
  modal(9);

  final int value;
  const InteractionCallbackType(this.value);
}

class Interaction {
  Snowflake applicationId;
  int version;
  InteractionType type;
  String token;
  User user;
  Guild? guild;

  Interaction({ required this.applicationId, required this.version, required this.type, required this.token, required this.user });
}
