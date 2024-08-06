import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';

abstract interface class ButtonContext {
  Snowflake get id;
  Snowflake get applicationId;
  String get token;
  int get version;
  Member get member;
}
