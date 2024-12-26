import 'dart:async';
import 'dart:io';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class ServerPart implements ServerPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Server> get(String id, bool force) async {
    final completer = Completer<Server>();
    final String key = _marshaller.cacheKey.server(id);

    final cachedServer = await _marshaller.cache.get(key);
    if (!force && cachedServer != null) {
      final server = await _marshaller.serializers.server.serialize(cachedServer);
      completer.complete(server);

      return completer.future;
    }

    final response = await _dataStore.client.get('/guilds/$id');

    final rawServer = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.server.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    final server = await _marshaller.serializers.server.serialize(rawServer);
    completer.complete(server);

    return completer.future;
  }

  @override
  Future<Server> updateServer(Snowflake id, Map<String, dynamic> payload, String? reason) async {
    final response = await _dataStore.client.patch('/guilds/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final rawServer = await _marshaller.serializers.server.normalize(response.body);
    return _marshaller.serializers.server.serialize(rawServer);
  }

  @override
  Future<List<T>> getChannels<T extends ServerChannel>(Snowflake id) async {
    final response = await _dataStore.client.get('/guilds/$id/channels');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    return Future.wait(List.from(response.body).map((element) async {
      final channel = await _marshaller.serializers.channels.normalize(element);
      return _marshaller.serializers.channels.serialize(channel) as Future<T>;
    }).toList());
  }

  @override
  Future<Role> getRole(Snowflake serverId, Snowflake roleId) async {
    final roleCacheKey = _marshaller.cacheKey.serverRole(serverId.value, roleId.value);
    final cachedRawRole = await _marshaller.cache.get(roleCacheKey);
    if (cachedRawRole != null) {
      return _marshaller.serializers.role.serialize(cachedRawRole);
    }

    final response = await _dataStore.client.get('/guilds/$serverId/roles/$roleId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final rolePayload = await _marshaller.serializers.role.normalize(response.body);
    return _marshaller.serializers.role.serialize(rolePayload);
  }

  @override
  Future<List<Role>> getRoles(Snowflake guildId, {bool force = false}) async {
    final response = await _dataStore.client.get('/guilds/$guildId/roles');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    return Future.wait(List.from(response.body).map((element) async {
      final payload = await _marshaller.serializers.role.normalize(element);
      return _marshaller.serializers.role.serialize(payload);
    }).toList());
  }
}
