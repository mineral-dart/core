import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';

abstract class Message<T extends Channel> {
  Snowflake get id;
  String? get content;
  Snowflake get channelId;
  abstract T channel;
}
