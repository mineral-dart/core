import 'package:mineral/api.dart';

class Application {
  Snowflake _id;
  int _flags;

  Application(this._id, this._flags);

  Snowflake get id => _id;
  int get flags => _flags;

  factory Application.from(dynamic payload) {
    return Application(
      payload['id'],
      payload['flags']
    );
  }
}
