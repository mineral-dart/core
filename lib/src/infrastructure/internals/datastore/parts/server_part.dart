import 'dart:async';
import 'dart:io';

import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/src/infrastructure/kernel/kernel.dart';
import 'package:mineral/src/infrastructure/services/http/http_client_status.dart';

final class ServerPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  ServerPart(this._kernel);

  Future<Server> getServer(Snowflake id) async {
    final cacheKey = _kernel.marshaller.cacheKey;
    final serverCacheKey = cacheKey.server(id);
    final rawServer = await _kernel.marshaller.cache.get(serverCacheKey);

    if (rawServer != null) {
      return _kernel.marshaller.serializers.server.serialize(rawServer);
    }

    final serverResponse = await _kernel.dataStore.client.get('/guilds/$id');

    await getChannels(id);
    await _kernel.dataStore.member.getMembers(id);

    final payload = await _kernel.marshaller.serializers.server
        .normalize(serverResponse.body);
    return _kernel.marshaller.serializers.server.serialize(payload);
  }

  Future<List<T>> getChannels<T extends ServerChannel>(Snowflake id) async {
    final response = await _kernel.dataStore.client.get('/guilds/$id/channels');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    return Future.wait(List.from(response.body).map((element) async {
      final channel =
          await _kernel.marshaller.serializers.channels.normalize(element);
      return _kernel.marshaller.serializers.channels.serialize(channel)
          as Future<T>;
    }).toList());
  }

  Future<Role> getRole(Snowflake serverId, Snowflake roleId) async {
    final roleCacheKey =
        _kernel.marshaller.cacheKey.serverRole(serverId, roleId);
    final cachedRawRole = await _kernel.marshaller.cache.get(roleCacheKey);
    if (cachedRawRole != null) {
      return _kernel.marshaller.serializers.role.serialize(cachedRawRole);
    }

    final response =
        await _kernel.dataStore.client.get('/guilds/$serverId/roles/$roleId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final rolePayload =
        await _kernel.marshaller.serializers.role.normalize(response.body);
    return _kernel.marshaller.serializers.role.serialize(rolePayload);
  }

  Future<List<Role>> getRoles(Snowflake guildId, {bool force = false}) async {
    final response =
        await _kernel.dataStore.client.get('/guilds/$guildId/roles');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    return Future.wait(List.from(response.body).map((element) async {
      final payload =
          await _kernel.marshaller.serializers.role.normalize(element);
      return _kernel.marshaller.serializers.role.serialize(payload);
    }).toList());
  }
}
