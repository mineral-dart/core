import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class GuildRoleManager extends CacheManager<Role> with Container {
  final Snowflake _guildId;

  GuildRoleManager(this._guildId);

  Guild get guild => container.use<MineralClient>().guilds.cache.getOrFail(_guildId);
  Role get everyone => cache.findOrFail((role) => role.label == '@everyone');

  /// Synchronise the cache from the Discord API
  ///
  /// Example :
  /// ```dart
  /// await guild.roles.sync();
  /// ```
  Future<Map<Snowflake, Role>> sync () async {
    cache.clear();

    Response response = await container.use<HttpService>().get(url: "/guilds/$_guildId/roles");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      Role role = Role.from(
        roleManager: this,
        payload: element,
      );
      cache.putIfAbsent(role.id, () => role);
    }

    return cache;
  }

  /// Create a this
  ///
  /// Warning: if you want to define an icon, the [Guid] must have the feature [GuildFeature.roleIcons]
  ///
  /// Example :
  /// ```dart
  /// await guild.roles.create(
  ///   label: 'My role',
  ///   color: Color.cyan_600,
  ///   permissions: [Permission.moderateMembers, Permission.banMembers],
  ///   hoist: true,
  /// );
  /// ```
  Future<Role> create ({ required String label, Color? color, bool? hoist, String? icon, String? unicode, bool? mentionable, List<Permission>? permissions }) async {
    if ((icon != null || unicode != null) && !guild.features.contains(GuildFeature.roleIcons)) {
      throw MissingFeatureException("Guild ${guild.name} has no 'ROLE_ICONS' feature.");
    }

    String? _icon = icon != null ? await Helper.getPicture(icon) : null;
    int? _permissions = permissions != null ? Helper.reduceRolePermissions(permissions) : null;

    Response response = await container.use<HttpService>().post(url: "/guilds/$_guildId}/roles", payload: {
      'name': label,
      'color': color != null ? Helper.toRgbColor(color) : null,
      'hoist': hoist ?? false,
      'mentionable': mentionable ?? false,
      'unicode_emoji': unicode,
      'icon': _icon,
      'permissions': _permissions
    });

    Role role = Role.from(
      roleManager: this,
      payload: jsonDecode(response.body),
    );

    cache.putIfAbsent(role.id, () => role);

    return role;
  }
}
