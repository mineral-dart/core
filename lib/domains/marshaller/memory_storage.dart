import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/server.dart';

abstract interface class MemoryStorageContract {
  Map<Snowflake, Server> get servers;
  Map<Snowflake, Channel> get channels;
}

final class MemoryStorage implements MemoryStorageContract {
  @override
  final Map<Snowflake, Server> servers = {};

  @override
  final Map<Snowflake, Channel> channels = {};
}
