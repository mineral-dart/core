import 'package:mineral/api/common/snowflake.dart';

abstract interface class DialogContext {
  Snowflake get id;
  Snowflake get applicationId;
  String get token;
  int get version;
  String get customId;
}
