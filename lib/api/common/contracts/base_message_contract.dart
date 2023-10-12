import 'package:mineral/api/common/snowflake.dart';

abstract interface class BaseMessageContract {
  abstract final Snowflake id;
  abstract final Snowflake channelId;
  abstract final String content;
}