import 'package:mineral/api/common/snowflake.dart';

abstract class Message {
  Snowflake get id;
  String? get content;
}
