import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';

final class RolePart implements RolePartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, Role>> fetch(Object serverId, bool force) async {
    final completer = Completer<Map<Snowflake, Role>>();

    final req = Request.json(endpoint: '/guilds/$serverId/roles');
    final result = await _dataStore.requestBucket
        .run<List>(() => _dataStore.client.get(req));

    final roles = await result.map((element) async {
      final raw = await _marshaller.serializers.role.normalize({
        ...element,
        'guild_id': serverId,
      });

      return _marshaller.serializers.role.serialize(raw);
    }).wait;

    completer
        .complete(roles.asMap().map((_, value) => MapEntry(value.id, value)));
    return completer.future;
  }

  @override
  Future<Role?> get(Object serverId, Object id, bool force) async {
    final completer = Completer<Role>();
    final String key = _marshaller.cacheKey.serverRole(serverId, id);

    final cachedRole = await _marshaller.cache?.get(key);
    if (!force && cachedRole != null) {
      final role = await _marshaller.serializers.role.serialize(cachedRole);

      completer.complete(role);
      return completer.future;
    }

    final req = Request.json(endpoint: '/guilds/$serverId/roles/$id');
    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.get(req));

    final raw = await _marshaller.serializers.role.normalize(result);
    final channel = await _marshaller.serializers.role.serialize(raw);

    completer.complete(channel);
    return completer.future;
  }

  @override
  Future<Role> create(
      Object serverId,
      String name,
      List<Permission> permissions,
      Color color,
      bool hoist,
      bool mentionable,
      String? reason) async {
    final completer = Completer<Role>();

    final req = Request.json(endpoint: '/guilds/$serverId/roles', body: {
      'name': name,
      'permissions': listToBitfield(permissions),
      'color': color.toInt(),
      'hoist': hoist,
      'mentionable': mentionable,
    }, headers: {
      DiscordHeader.auditLogReason(reason)
    });

    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.post(req));

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
      {required Object memberId,
      required Object serverId,
      required Object roleId,
      required String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$serverId/members/$memberId/roles/$roleId',
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.put(req));
  }

  @override
  Future<void> remove(
      {required Object memberId,
      required Object serverId,
      required Object roleId,
      required String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$serverId/members/$memberId/roles/$roleId',
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.delete(req));
  }

  @override
  Future<void> sync(
      {required Object memberId,
      required Object serverId,
      required List<Object> roleIds,
      required String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$serverId/members/$memberId',
        body: {'roles': roleIds},
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.patch(req));
  }

  @override
  Future<Role?> update(
      {required Object id,
      required Object serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final completer = Completer<Role?>();
    final req = Request.json(
        endpoint: '/guilds/$serverId/roles/$id',
        body: payload,
        headers: {DiscordHeader.auditLogReason(reason)});

    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.patch(req));

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
      {required Object id,
      required Object guildId,
      required String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$guildId/roles/$id',
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.delete(req));
  }
}
