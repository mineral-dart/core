import 'package:mineral/src/api/common/channel_methods.dart';
import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/channel_properties.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';

final class ServerCategoryChannel extends ServerChannel {
  final ChannelProperties _properties;
  late final ChannelMethods _methods;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name!;

  @override
  DateTime get createdAt => id.createdAt;

  int get position => _properties.position!;

  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  ThreadsManager get threads => _properties.threads;

  @override
  Snowflake get serverId => _properties.serverId!;

  ServerCategoryChannel(this._properties) {
    _methods = ChannelMethods(_properties.serverId!, _properties.id);
  }

  /// Sets the name of the channel.
  ///
  /// ```dart
  /// await channel.setName('new-name');
  /// ```
  Future<void> setName(String name, {String? reason}) =>
      _methods.setName(name, reason);

  /// Sets the position of the channel.
  ///
  /// ```dart
  /// await channel.setPosition(1);
  /// ```
  Future<void> setPosition(int position, {String? reason}) =>
      _methods.setPosition(position, reason);

  /// Deletes the channel.
  ///
  /// ```dart
  /// await channel.delete();
  /// ```
  Future<void> delete({String? reason}) => _methods.delete(reason);
}
