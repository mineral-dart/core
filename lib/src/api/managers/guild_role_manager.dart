import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class GuildRoleManager extends CacheManager<Role> {
  late final Guild guild;

  /// Synchronise the cache from the Discord API
  ///
  /// Example :
  /// ```dart
  /// await guild.roles.sync();
  /// ```
  Future<Map<Snowflake, Role>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/${guild.id}/roles");
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
    if ((icon != null || unicode != null) && !guild.features.contains('ROLE_ICONS')) {
      throw MissingFeatureException(cause: "Guild ${guild.name} has no 'ROLE_ICONS' feature.");
    }

    String? _icon = icon != null ? await Helper.getPicture(icon) : null;
    int? _permissions = permissions != null ? Helper.reduceRolePermissions(permissions) : null;

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.post(url: "/guilds/${guild.id}/roles", payload: {
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
