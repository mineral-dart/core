import 'package:mineral/api.dart';

class Interaction {
  Snowflake applicationId;
  int version;
  InteractionType type;
  String token;
  User user;
  Guild? guild;

  Interaction({ required this.applicationId, required this.version, required this.type, required this.token, required this.user });
}
