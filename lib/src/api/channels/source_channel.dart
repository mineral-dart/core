import 'package:mineral/core/api.dart';

class SourceChannel {
  final Snowflake _id;
  final String _label;

  SourceChannel(this._id, this._label);

  Snowflake get id => _id;
  String get label => _label;
}