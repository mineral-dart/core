import 'package:mineral/api.dart';

class PartialChannel {
  final Snowflake _id;

  PartialChannel(this._id);

  Snowflake get id => _id;
}
