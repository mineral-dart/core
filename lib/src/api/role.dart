import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';

class Tag {
  Snowflake? botId;
  Snowflake? integrationId;
  bool? premiumSubscriber;

  Tag({ required this.botId, required Snowflake? integrationId, required bool? premiumSubscriber });

  factory Tag.from({ required payload }) {
    return Tag(
      botId: payload['bot_id'],
      integrationId: payload['integration_id'],
      premiumSubscriber: payload['premium_subscriber']
    );
  }
}

class Role {
  Snowflake id;
  String label;
  int color;
  bool hoist;
  String? icon;
  String? unicodeEmoji;
  int position;
  int permissions;
  bool managed;
  bool mentionable;
  Tag? tags;
  GuildRoleManager manager;

  Role({
    required this.id,
    required this.label,
    required this.color,
    required this.hoist,
    required this.icon,
    required this.unicodeEmoji,
    required this.position,
    required this.permissions,
    required this.managed,
    required this.mentionable,
    required this.tags,
    required this.manager,
  });

  /// Modifies the [label] of the role.
  /// ```dart
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// if (role != null) {
  ///   await role.setLabel('New label');
  /// }
  /// ```
  Future<void> setLabel (String label) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/guilds/${manager.guildId}/roles/$id", payload: { 'name': label });
    if (response.statusCode == 200) {
      this.label = label;
    }
  }

  /// Modifies the permissions associated with this
  /// ```dart
  /// import 'package:mineral/api.dart'; 👈 // then you can use Permission class
  ///
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// if (role != null) {
  ///   await role.setPermissions([Permission.kickMembers, Permission.banMembers]);
  /// }
  ///
  Future<void> setPermissions (List<Permission> permissions) async {
    Http http = ioc.singleton(ioc.services.http);

    int _permissions = Helper.reduceRolePermissions(permissions);
    Response response = await http.patch(url: "/guilds/${manager.guildId}/roles/$id", payload: { 'permissions': _permissions });

    if (response.statusCode == 200) {
      this.permissions = _permissions;
    }
  }

  /// Modifies the [color] of the role.
  /// ```dart
  /// import 'package:mineral/api.dart'; 👈 // then you can use Color class
  ///
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// if (role != null) {
  ///   await role.setColor(Color.cyan_600);
  /// }
  /// ```
  /// You can use a custom colour from a hexadecimal format.
  /// ```dart
  /// await role.setColor(Color('#ffffff'));
  /// ```
  Future<void> setColor (Color color) async {
    Http http = ioc.singleton(ioc.services.http);

    int _color = Helper.toRgbColor(color);
    Response response = await http.patch(url: "/guilds/${manager.guildId}/roles/$id", payload: { 'color': _color });
    if (response.statusCode == 200) {
      this.color = _color;
    }
  }

  /// Modifies the [hoist] of the role from [bool].
  /// ```dart
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// if (role != null) {
  ///   await role.setHoist(true);
  /// }
  /// ```
  Future<void> setHoist (bool hoist) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/guilds/${manager.guildId}/roles/$id", payload: { 'hoist': hoist });
    if (response.statusCode == 200) {
      this.hoist = hoist;
    }
  }

  /// Modifies the [icon] of the role from [String] path.
  ///
  /// We consider having the file structure
  /// ```
  /// .dart_tool
  /// assets/
  ///   images/
  ///     penguin.png
  /// src/
  /// test/
  /// .env
  /// pubspec.yaml
  /// ```
  /// ```dart
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// if (role != null) {
  ///   await role.setIcon('assets/images/penguin.png');
  /// }
  /// ```
  Future<void> setIcon (String path) async {
    if (!manager.guild.features.contains(GuildFeature.roleIcons)) {
      throw MissingFeatureException(cause: "Guild ${manager.guild.name} has no 'ROLE_ICONS' feature.");
    }

    String icon = await Helper.getPicture(path);

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/${manager.guildId}/roles/$id", payload: { 'icon': icon });
    if (response.statusCode == 200) {
      this.icon = icon;
    }
  }

  /// Remove the [icon] of the role.
  ///
  /// Your guild requires the [GuildFeature.roleIcons] to perform this action, otherwise throw [MissingFeatureException].
  /// ```dart
  /// import 'package:mineral/api.dart'; 👈 // then you can use GuildFeature enum
  ///
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// final bool hasFeature = guild.features.contains(GuildFeature.roleIcons);
  ///
  /// if (hasFeature && role != null) {
  ///   await role.removeIcon();
  /// }
  /// ```
  Future<void> removeIcon () async {
    if (!manager.guild.features.contains(GuildFeature.roleIcons)) {
      throw MissingFeatureException(cause: "Guild ${manager.guild.name} has no 'ROLE_ICONS' feature.");
    }

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/${manager.guildId}/roles/$id", payload: { 'icon': null });
    if (response.statusCode == 200) {
      icon = null;
    }
  }

  /// Define the [unicodeEmoji] of the role from [String].
  ///
  /// Your guild requires the [GuildFeature.roleIcons] to perform this action, otherwise throw [MissingFeatureException].
  /// ```dart
  /// import 'package:mineral/api.dart'; 👈 // then you can use GuildFeature enum
  ///
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// final bool hasFeature = guild.features.contains(GuildFeature.roleIcons);
  ///
  /// if (hasFeature && role != null) {
  ///   await role.setUnicodeEmoji('😍');
  /// }
  /// ```
  Future<void> setUnicodeEmoji (String unicode) async {
    if (!manager.guild.features.contains(GuildFeature.roleIcons)) {
      throw MissingFeatureException(cause: "Guild ${manager.guild.name} has no 'ROLE_ICONS' feature.");
    }

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/${manager.guildId}/roles/$id", payload: { 'unicode_emoji': unicode });
    if (response.statusCode == 200) {
      unicodeEmoji = unicode;
    }
  }

  /// Modifies the [mentionable] of the role from [bool].
  /// ```dart
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// if (role != null) {
  ///   await role.setMentionable(true);
  /// }
  /// ```
  Future<void> setMentionable (bool mentionable) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/${manager.guildId}/roles/$id", payload: { 'mentionable': mentionable });

    if (response.statusCode == 200) {
      this.mentionable = mentionable;
    }
  }

  /// Removes the current this from the [MemberRoleManager]'s cache
  /// ```dart
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// if (role != null) {
  ///   await role.delete();
  /// }
  /// ```
  /// You can specify a reason for this action
  /// ```dart
  /// await role.delete(reason: 'I will destroy this..');
  /// ```
  /// You can't delete `@everyone` and [managed] roles.
  ///
  Future<void> delete () async {
    if (managed || label == '@everyone') {
      return;
    }

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.destroy(url: "/guilds/${manager.guildId}/roles/$id");

    if (response.statusCode == 200) {
      manager.cache.remove(id);
    }
  }

  /// Returns this in discord notification format
  /// ```dart
  /// final Role? role = guild.roles.cache.get('240561194958716924');
  /// if (role != null) {
  ///   print(role.toString()) // print('<@&240561194958716924>')
  ///   print('$role') // print('<@&240561194958716924>')
  /// }
  /// ```
  @override
  String toString () => '<@&$id>';

  factory Role.from({ required GuildRoleManager roleManager, dynamic payload }) {
    return Role(
      id: payload['id'],
      label: payload['name'],
      color: payload['color'],
      hoist: payload['hoist'],
      icon: payload['icon'],
      unicodeEmoji: payload['unicode_emoji'],
      position: payload['position'],
      permissions: payload['permissions'],
      managed: payload['managed'],
      mentionable: payload['mentionable'],
      tags: payload['tags'] != null ? Tag.from(payload: payload['tags']) : null,
      manager: roleManager,
    );
  }
}
