import 'package:mineral/api.dart';
import 'package:mineral/api/server/managers/threads_manager.dart';

final class ServerCategoryChannel extends ServerChannel {
  final ChannelProperties _properties;
  final ChannelMethods _methods;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name!;

  @override
  int get position => _properties.position!;

  @override
  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  @override
  ThreadsManager get threads => _properties.threads;

  @override
  Snowflake get serverId => _properties.serverId!;

  @override
  late final Server server;

  ServerCategoryChannel(this._properties)
      : _methods = ChannelMethods(_properties.id);

  Future<void> setName(String name, {String? reason}) =>
      _methods.setName(name, reason);

  Future<void> setPosition(int position, {String? reason}) =>
      _methods.setPosition(position, reason);

  Future<void> delete({String? reason}) => _methods.delete(reason);
}
