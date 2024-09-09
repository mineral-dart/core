import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/api/server/server.dart';

abstract class ServerChannel implements Channel {
  abstract Server server;
  String get name;
  List<ChannelPermissionOverwrite> get permissions;
  int get position;
  Snowflake get serverId;
  ThreadsManager get threads;

  @override
  T cast<T extends Channel>() => this as T;
}
