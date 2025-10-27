import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';

abstract class Channel {
  Snowflake get id;
  ChannelType get type;
  DateTime get createdAt => id.createdAt;
  T cast<T extends Channel>() => this as T;
}

final class UnknownChannel extends Channel {
  @override
  final Snowflake id;

  @override
  final ChannelType type = ChannelType.unknown;

  final String name;

  UnknownChannel({
    required this.id,
    required this.name,
  });
}
