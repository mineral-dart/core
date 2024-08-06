import 'package:mineral/api/common/snowflake.dart';

abstract interface class ButtonContext {
  Snowflake get id;
  Snowflake get applicationId;
  String get token;
  int get version;
}
