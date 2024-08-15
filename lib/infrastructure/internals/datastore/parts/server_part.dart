import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/response.dart';

final class ServerPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  ServerPart(this._kernel);

  Future<Server> getServer(Snowflake id) async {
    final cacheKey = _kernel.marshaller.cacheKey;
    final serverCacheKey = cacheKey.server(id);

    final rawServer = await _kernel.marshaller.cache.get(serverCacheKey);
    if (rawServer != null) {
      return _kernel.marshaller.serializers.server.serializeCache(rawServer);
    }

    final [serverResponse, channelsResponse, membersResponse] = await Future.wait([
      _kernel.dataStore.client.get('/guilds/$id'),
      _kernel.dataStore.client.get('/guilds/$id/channels'),
      _kernel.dataStore.client.get('/guilds/$id/members')
    ]);

    final server = await _kernel.marshaller.serializers.server.serializeRemote({
      ...serverResponse.body,
      'channels': channelsResponse.body,
      'members': membersResponse.body
    });

    await Future.wait([
      _kernel.marshaller.cache.put(serverCacheKey, await _kernel.marshaller.serializers.server.deserialize(server)),
      ...server.channels.list.values.map((channel) {
        final channelCacheKey = cacheKey.channel(channel.id);
        final rawChannel = _kernel.marshaller.serializers.channels.deserialize(channel);

        return _kernel.marshaller.cache.put(channelCacheKey, rawChannel);
      }),
      ...server.members.list.values.map((member) {
        final memberCacheKey = cacheKey.serverMember(serverId: id, memberId: member.id);
        final rawMember = _kernel.marshaller.serializers.member.deserialize(member);

        return _kernel.marshaller.cache.put(memberCacheKey, rawMember);
      })
    ]);

    return server;
  }

  Future<Role> getRole(Snowflake guildId, Snowflake id) async {
    final cachedRawRole = await _kernel.marshaller.cache.get(id.value);
    if (cachedRawRole != null) {
      return _kernel.marshaller.serializers.role.serializeRemote(cachedRawRole);
    }

    final response = await _kernel.dataStore.client.get('/guilds/$guildId/roles');
    final roles = await _serializeRolesResponse(response);
    final role = roles.firstWhere((role) => role.id == id);

    final roleCacheKey = _kernel.marshaller.cacheKey.serverRole(serverId: guildId, roleId: id);
    final rawRole = await _kernel.marshaller.serializers.role.deserialize(role);
    await _kernel.marshaller.cache.put(roleCacheKey, rawRole);

    return role;
  }

  Future<List<Role>> getRoles(Snowflake guildId, {bool force = false}) async {
    if (force) {
      final response = await _kernel.dataStore.client.get('/guilds/$guildId/roles');
      final roles = await _serializeRolesResponse(response);

      for (final role in roles) {
        final roleCacheKey =
            _kernel.marshaller.cacheKey.serverRole(serverId: guildId, roleId: role.id);
        final rawRole = await _kernel.marshaller.serializers.role.deserialize(role);

        await _kernel.marshaller.cache.put(roleCacheKey, rawRole);
      }

      return roles;
    }

    final rowServer = await _kernel.dataStore.server.getServer(guildId);
    return rowServer.roles.list.values.toList();
  }

  Future<List<Role>> _serializeRolesResponse(Response response) {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => List.from(response.body)
          .map((element) => _kernel.marshaller.serializers.channels.serializeRemote(element)),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    } as Future<List<Role>>;
  }
}
