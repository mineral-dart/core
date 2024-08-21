import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';

abstract class Channel {
  Snowflake get id;
  ChannelType get type;
  T cast<T extends Channel>() => this as T;
}

final class UnknownChannel extends Channel {
  @override
  final Snowflake id;

  @override
  final ChannelType type = ChannelType.unknown;

  UnknownChannel(this.id);
}
