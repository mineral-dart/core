import 'dart:async';
import 'dart:io';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class RolePart implements RolePartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, Role>> fetch(String serverId, bool force) async {
    final completer = Completer<Map<Snowflake, Role>>();
    final response = await _dataStore.client.get('/guilds/$serverId/roles');

    final rawRoles = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => await Future.wait(
          List.from(response.body).map((element) async =>
              await _marshaller.serializers.role.normalize({...element, 'guild_id': serverId})),
        ),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    };

    final roles = await Future.wait(rawRoles.map((element) async {
      final role = await _marshaller.serializers.role.serialize(element);
      await _marshaller.cache
          .put(_marshaller.cacheKey.serverRole(serverId, role.id.value), element);

      return role;
    }));

    completer.complete(roles.asMap().map((_, value) => MapEntry(value.id, value)));
    return completer.future;
  }

  @override
  Future<Role?> get(String serverId, String id, bool force) async {
    final completer = Completer<Role>();
    final String key = _marshaller.cacheKey.serverRole(serverId, id);

    final cachedRole = await _marshaller.cache.get(key);
    if (!force && cachedRole != null) {
      final role = await _marshaller.serializers.role.serialize(cachedRole);
      completer.complete(role);

      return completer.future;
    }

    final response = await _dataStore.client.get('/guilds/$serverId/roles/$id');
    final role = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.role.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.role.serialize(role));

    return completer.future;
  }

  @override
  Future<Role> create(String serverId, String name, List<Permission> permissions, Color color,
      bool hoist, bool mentionable, String? reason) async {
    final completer = Completer<Role>();

    final response = await _dataStore.client.post('/guilds/$serverId/roles',
        body: {
          'name': name,
          'permissions': listToBitfield(permissions),
          'color': color.toInt(),
          'hoist': hoist,
          'mentionable': mentionable,
        },
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final role = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.role.normalize({
          ...response.body,
          'guild_id': serverId,
        }),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.role.serialize(role));
    return completer.future;
  }

  @override
  Future<void> addRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason}) async {
    await _dataStore.client.put('/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }

  @override
  Future<void> removeRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason}) async {
    await _dataStore.client.delete('/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }

  @override
  Future<void> syncRoles(
      {required Snowflake memberId,
      required Snowflake serverId,
      required List<Snowflake> roleIds,
      required String? reason}) async {
    await _dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: {'roles': roleIds},
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }

  @override
  Future<Role?> updateRole(
      {required Snowflake id,
      required Snowflake serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch('/guilds/$serverId/roles/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final body = await _marshaller.serializers.role.normalize(response.body);
    return _marshaller.serializers.role.serialize(body);
  }

  @override
  Future<void> deleteRole(
      {required Snowflake id, required Snowflake guildId, required String? reason}) async {
    await _dataStore.client.delete('/guilds/$guildId/roles/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }
}
