import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/extras.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral/src/exceptions/not_exist_exception.dart';
import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_ioc/ioc.dart';

class MemberRoleManager extends CacheManager<Role> with Container {
  late final Guild _guild;
  GuildRoleManager manager;
  Snowflake memberId;

  MemberRoleManager({ required this.manager, required this.memberId });

  Guild get guild => _guild;

  Role get highest => cache.values.fold(_guild.roles.everyone, (previousValue, element) {
    if (element.position > previousValue.position) return element;
    return previousValue;
  });

  /// Add a [Role] to the [GuildMember]
  ///
  /// Example :
  /// ```dart
  /// final Role? role = guild.roles.cache.get('446556480850755604');
  /// final GuildMember? member = guild.members.cache.get('240561194958716924');
  ///
  /// if (member != null && role != null) {
  ///   await member.roles.add(role.id)
  /// }
  /// ```
  /// You can pass a reason for the audit logs.
  ///
  /// Example :
  /// ```dart
  /// await member.roles.add('446556480850755604', reason: 'I love this user');
  /// ```
  Future<void> add (Snowflake id, {String? reason}) async {
    Role? role = manager.cache.get(id);

    if(role == null) {
      throw NotExistException('You can\'t add a role that don\'t exist!');
    }

    Response response = await ioc.use<DiscordApiHttpService>()
      .put(url: '/guilds/${manager.guild.id}/members/$memberId/roles/$id')
      .auditLog(reason)
      .build();

    if (response.statusCode == 204) {
      cache.putIfAbsent(id, () => role);
      return;
    }

    final payload = jsonDecode(response.body);

    if(payload['code'] == DiscordErrorsCode.missingPermissions.value) {
      container.use<ConsoleService>().warn('Bot don\'t have permissions to add or remove roles !');
      return;
    }
  }

  /// Remove a [Role] from the [GuildMember]
  ///
  /// Example :
  /// ```dart
  /// final Role? role = guild.roles.cache.get('446556480850755604');
  /// final GuildMember? member = guild.members.cache.get('240561194958716924');
  /// if (member != null && role != null) {
  ///   await member.roles.remove(role.id)
  /// }
  /// ```
  ///
  /// You can pass a reason for the audit logs.
  ///
  /// Example :
  /// ```dart
  /// await member.roles.remove('446556480850755604', reason: 'Hello, World!');
  /// ```
  Future<void> remove (Snowflake id, {String? reason}) async {
    Response response = await ioc.use<DiscordApiHttpService>().destroy(url: '/guilds/${manager.guild.id}/members/$memberId/roles/$id')
      .auditLog(reason)
      .build();

    if (response.statusCode == 204) {
      cache.remove(id);
      return;
    }

    final payload = jsonDecode(response.body);

    if(payload['code'] == DiscordErrorsCode.missingPermissions.value) {
      container.use<ConsoleService>().warn('Bot don\'t have permissions to add or remove roles !');
      return;
    }
  }

  /// Toggle a [Role] from the [GuildMember]. If the user has the role, this method will remove the role, else this method will add the role.
  ///
  /// Example :
  /// ```dart
  /// final Role? role = guild.roles.cache.get('446556480850755604');
  /// final GuildMember? member = guild.members.cache.get('240561194958716924');
  /// if (member != null && role != null) {
  ///   await member.roles.toggle(role.id)
  /// }
  /// ```
  ///
  /// You can pass a reason for the audit logs.
  ///
  /// Example :
  /// ```dart
  /// await member.roles.toggle('446556480850755604', reason: 'Hello, World!');
  /// ```
  Future<void> toggle (Snowflake id, {String? reason}) async {
    return cache.containsKey(id)
      ? remove(id, reason: reason)
      : add(id, reason: reason);
  }

  Future<Map<Snowflake, Role>> sync () async {
    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: "/guilds/${manager.guild.id}/members/$memberId")
      .build();

    if (response.statusCode == 200) {
      cache.clear();
      dynamic payload = jsonDecode(response.body)['roles'];

      for (final element in payload) {
        final Role? role = manager.cache.get(element);
        if (role != null) {
          cache.putIfAbsent(role.id, () => role);
        }
      }
    }

    return cache;
  }

  Future<Role> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    await sync();
    if (!cache.containsKey(id)) {
      throw ApiException('Unable to fetch role with id #$id');
    }

    return cache.getOrFail(id);
  }
}
