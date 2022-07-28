import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/exceptions/not_exist.dart';

class MemberRoleManager extends CacheManager<Role> {
  late final Guild _guild;
  GuildRoleManager manager;
  Snowflake memberId;

  MemberRoleManager({ required this.manager, required this.memberId });

  Guild get guild => _guild;

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
    Http http = ioc.singleton(ioc.services.http);
    Role? role = manager.cache.get(id);

    if(role == null) {
      throw NotExist(prefix: 'role not exist', cause: 'You can\'t add a role that don\'t exist!');
    }

    Map<String, String> headers = {};
    if(reason != null) {
      headers.putIfAbsent('X-Audit-Log-Reason', () => reason);
    }

    Response response = await http.put(
      url: '/guilds/${manager.guild.id}/members/$memberId/roles/$id',
      payload: {},
      headers: headers
    );

    if(response.statusCode == 204) {
      cache.putIfAbsent(id, () => role);
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
    Http http = ioc.singleton(ioc.services.http);

    Map<String, String> headers = {};
    if(reason != null) {
      headers.putIfAbsent('X-Audit-Log-Reason', () => reason);
    }

    Response response = await http.destroy(
      url: '/guilds/${manager.guild.id}/members/$memberId/roles/$id',
      headers: headers
    );

    if(response.statusCode == 204) {
      cache.remove(id);
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
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.get(url: "/guilds/${manager.guild.id}/members/$memberId");
    if(response.statusCode == 200) {
      cache.clear();
      dynamic payload = jsonDecode(response.body)['roles'];

      for(dynamic element in payload) {
        final Role? role = manager.cache.get(element);
        if(role != null) {
          cache.putIfAbsent(role.id, () => role);
        }
      }
    }

    return cache;
  }

}
