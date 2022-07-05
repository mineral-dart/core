import 'package:mineral/api.dart';

class Application {
  Snowflake id;
  int flags;

  Application({ required this.id, required this.flags });

  factory Application.from(dynamic payload) {
    return Application(
      id: payload['id'],
      flags: payload['flags']
    );
  }
}
