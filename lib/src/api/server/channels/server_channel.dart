import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/api/server/server.dart';

abstract class ServerChannel implements Channel {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  String get name;

  List<ChannelPermissionOverwrite> get permissions;

  int get position;

  Snowflake get serverId;

  ThreadsManager get threads;

  Future<Server> resolveServer({bool force = true}) => _dataStore.server.get(serverId.value, force);

  @override
  T cast<T extends Channel>() => this as T;
}
