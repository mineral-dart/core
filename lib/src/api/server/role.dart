import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/color.dart';
import 'package:mineral/src/api/common/permissions.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/server.dart';

final class Role {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake id;
  final String name;
  final Color color;
  final bool hoist;
  final int position;
  final bool managed;
  final bool mentionable;
  final int flags;
  final String? icon;
  final String? unicodeEmoji;
  final Permissions permissions;
  final Snowflake serverId;

  Role({
    required this.id,
    required this.name,
    required this.color,
    required this.hoist,
    required this.position,
    required this.permissions,
    required this.managed,
    required this.mentionable,
    required this.flags,
    required this.icon,
    required this.unicodeEmoji,
    required this.serverId,
  });

  // todo: setPermissions, setPositions methods

  /// Set the role's name.
  ///
  /// ```dart
  ///  await role.setName('New Role Name', reason: 'Testing');
  ///  ```
  Future<void> setName(String name, String? reason) async {
    await _datastore.role.updateRole(
      id: id,
      serverId: serverId,
      reason: reason,
      payload: {'name': name},
    );
  }

  /// Set the role's color.
  ///
  /// ```dart
  /// await role.setColor(Color.fromRGB(255, 0, 0), reason: 'Testing');
  /// ```
  Future<void> setColor(Color color, String? reason) async {
    await _datastore.role.updateRole(
      id: id,
      serverId: serverId,
      reason: reason,
      payload: {'color': color.toInt()},
    );
  }

  /// Set the role's hoist status.
  ///
  /// ```dart
  ///  await role.setHoist(true, reason: 'Testing');
  /// ```
  Future<void> setHoist(bool hoist, String? reason) async {
    await _datastore.role.updateRole(
      id: id,
      serverId: serverId,
      reason: reason,
      payload: {'hoist': hoist},
    );
  }

  /// Set the role's emoji.
  ///
  /// ```dart
  /// await role.setUnicodeEmoji('👑', reason: 'Testing');
  /// ```
  Future<void> setUnicodeEmoji(String emoji, String? reason) async {
    await _datastore.role.updateRole(
      id: id,
      serverId: serverId,
      reason: reason,
      payload: {'unicode_emoji': emoji},
    );
  }

  /// Enable or disable the role's mentionable status.
  ///
  /// ```dart
  /// await role.setMentionable(true, reason: 'Testing');
  /// ```
  Future<void> setMentionable(bool value, String? reason) async {
    await _datastore.role.updateRole(
      id: id,
      serverId: serverId,
      reason: reason,
      payload: {'mentionable': value},
    );
  }

  /// Delete this role.
  ///
  /// ```dart
  /// await role.delete('Testing');
  /// ```
  Future<void> delete(String? reason) async {
    await _datastore.role.deleteRole(id: id, guildId: serverId, reason: reason);
  }

  /// Get the server this role belongs to.
  /// ```dart
  /// final server = await role.resolveServer();
  /// ```
  Future<Server> resolveServer({bool force = false }) => _datastore.server.get(serverId.value, force);
}
