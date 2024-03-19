import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';

abstract class Channel {
  Snowflake get id;
  ChannelType get type;
}
