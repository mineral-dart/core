import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/server/server.dart';

abstract interface class MemoryStorageContract {
  Map<String, Server> get servers;
  Map<String, Channel> get channels;
}

final class MemoryStorage implements MemoryStorageContract {
  @override
  final Map<String, Server> servers = {};

  @override
  final Map<String, Channel> channels = {};
}
