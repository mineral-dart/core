import 'dart:async';

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

    final result = await _dataStore.requestBucket
        .run<List>(() => _dataStore.client.get('/guilds/$serverId/roles'));

    final roles = await result.map((element) async {
      final raw = await _marshaller.serializers.role.normalize({
        ...element,
        'guild_id': serverId,
      });

      return _marshaller.serializers.role.serialize(raw);
    }).wait;

    completer.complete(roles.asMap().map((_, value) => MapEntry(value.id, value)));
    return completer.future;
  }

  @override
  Future<Role?> get(String serverId, String id, bool force) async {
    final completer = Completer<Role>();
    final String key = _marshaller.cacheKey.serverRole(serverId, id);

    final cachedRole = await _marshaller.cache?.get(key);
    if (!force && cachedRole != null) {
      final role = await _marshaller.serializers.role.serialize(cachedRole);

      completer.complete(role);
      return completer.future;
    }

    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.get('/guilds/$serverId/roles/$id'));

    final raw = await _marshaller.serializers.role.normalize(result);
    final channel = await _marshaller.serializers.role.serialize(raw);

    completer.complete(channel);
    return completer.future;
  }

  @override
  Future<Role> create(String serverId, String name, List<Permission> permissions, Color color,
      bool hoist, bool mentionable, String? reason) async {
    final completer = Completer<Role>();

    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.post('/guilds/$serverId/roles',
            body: {
              'name': name,
              'permissions': listToBitfield(permissions),
              'color': color.toInt(),
              'hoist': hoist,
              'mentionable': mentionable,
            },
            option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));

    final raw = await _marshaller.serializers.role.normalize(result);
    final role = await _marshaller.serializers.role.serialize({
      ...raw,
      'guild_id': serverId,
    });

    completer.complete(role);
    return completer.future;
  }

  @override
  Future<void> add(
      {required String memberId,
      required String serverId,
      required String roleId,
      required String? reason}) async {
    await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client.put(
        '/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));
  }

  @override
  Future<void> remove(
      {required String memberId,
      required String serverId,
      required String roleId,
      required String? reason}) async {
    await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client.delete(
        '/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));
  }

  @override
  Future<void> sync(
      {required String memberId,
      required String serverId,
      required List<String> roleIds,
      required String? reason}) async {
    await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client.patch(
        '/guilds/$serverId/members/$memberId',
        body: {'roles': roleIds},
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));
  }

  @override
  Future<Role?> update(
      {required String id,
      required String serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final completer = Completer<Role?>();
    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client
        .patch('/guilds/$serverId/roles/$id',
            body: payload,
            option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));

    final raw = await _marshaller.serializers.role.normalize(result);
    final role = await _marshaller.serializers.role.serialize({
      ...raw,
      'guild_id': serverId,
    });

    completer.complete(role);
    return completer.future;
  }

  @override
  Future<void> delete(
      {required String id, required String guildId, required String? reason}) async {
    await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client.delete(
        '/guilds/$guildId/roles/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));
  }
}
