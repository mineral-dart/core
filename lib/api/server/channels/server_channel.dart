import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/managers/threads_manager.dart';
import 'package:mineral/api/server/server.dart';

abstract class ServerChannel implements Channel {
  late final Server server;
  String get name;
  List<ChannelPermissionOverwrite> get permissions;
  int get position;
  Snowflake get serverId;
  ThreadsManager get threads;

  @override
  T cast<T extends Channel>() => this as T;
}
