import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';

abstract class ServerChannel implements Channel {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  String get name;

  Snowflake get serverId;

  Future<Server> resolveServer({bool force = true}) => _dataStore.server.get(serverId.value, force);

  /// Updates the channel.
  /// ```dart
  /// final builder = ChannelBuilder.text()
  ///  ..setName('new-name')
  ///  ..setPosition(1);
  ///
  /// await channel.update(builder);
  /// ```
  Future<void> update(ChannelBuilderContract builder, {String? reason}) =>
      _dataStore.channel.update(id, builder, serverId: serverId.value, reason: reason);

  @override
  T cast<T extends Channel>() => this as T;
}
