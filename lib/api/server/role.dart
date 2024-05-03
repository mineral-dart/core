import 'package:mineral/api/common/color.dart';
import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/data_store/data_store.dart';
import 'package:mineral/infrastructure/data_store/parts/role_part.dart';

final class Role {
  RolePart get dataStoreRole => DataStore.singleton().role;
  late final Server server;

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
  });

  Future<void> setName(String name, String? reason) async {
    await dataStoreRole.updateRole(
      id: id,
      serverId: server.id,
      reason: reason,
      payload: {'name': name},
    );
  }

  Future<void> setColor(Color color, String? reason) async {
    await dataStoreRole.updateRole(
      id: id,
      serverId: server.id,
      reason: reason,
      payload: {'color': color.toInt()},
    );
  }

  Future<void> setHoist(bool hoist, String? reason) async {
    await dataStoreRole.updateRole(
      id: id,
      serverId: server.id,
      reason: reason,
      payload: {'hoist': hoist},
    );
  }

  Future<void> setUnicodeEmoji(String emoji, String? reason) async {
    await dataStoreRole.updateRole(
      id: id,
      serverId: server.id,
      reason: reason,
      payload: {'unicode_emoji': emoji},
    );
  }

  Future<void> setMentionable(bool value, String? reason) async {
    await dataStoreRole.updateRole(
      id: id,
      serverId: server.id,
      reason: reason,
      payload: {'mentionable': value},
    );
  }

  Future<void> delete(String? reason) async {
    await dataStoreRole.deleteRole(id: id, guildId: server.id, reason: reason);
  }
}
