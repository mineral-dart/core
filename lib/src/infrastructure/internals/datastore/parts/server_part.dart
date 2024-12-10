import 'dart:async';
import 'dart:io';

import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class ServerPart implements DataStorePart {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  Future<Server> getServer(Snowflake id) async {
    final cacheKey = _marshaller.cacheKey;
    final serverCacheKey = cacheKey.server(id);
    final rawServer = await _marshaller.cache.get(serverCacheKey);

    if (rawServer != null) {
      return _marshaller.serializers.server.serialize(rawServer);
    }

    final serverResponse = await _dataStore.client.get('/guilds/$id');

    await getChannels(id);
    await _dataStore.member.getMembers(id);

    final payload =
        await _marshaller.serializers.server.normalize(serverResponse.body);
    return _marshaller.serializers.server.serialize(payload);
  }

  Future<Server> updateServer(
      Snowflake id, Map<String, dynamic> payload, String? reason) async {
    final response = await _dataStore.client.patch('/guilds/$id',
        body: payload,
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    final rawServer =
        await _marshaller.serializers.server.normalize(response.body);
    return _marshaller.serializers.server.serialize(rawServer);
  }

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

  Future<Role> getRole(Snowflake serverId, Snowflake roleId) async {
    final roleCacheKey = _marshaller.cacheKey.serverRole(serverId, roleId);
    final cachedRawRole = await _marshaller.cache.get(roleCacheKey);
    if (cachedRawRole != null) {
      return _marshaller.serializers.role.serialize(cachedRawRole);
    }

    final response =
        await _dataStore.client.get('/guilds/$serverId/roles/$roleId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final rolePayload =
        await _marshaller.serializers.role.normalize(response.body);
    return _marshaller.serializers.role.serialize(rolePayload);
  }

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
