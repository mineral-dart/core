import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';

abstract class Channel {
  final Snowflake id;
  final String name;

  final ChannelType type;

  const Channel(this.id, this.type, this.name);
}
