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
    final cachedRawServer = await _kernel.marshaller.cache.get(id);
    if (cachedRawServer != null) {
      return _kernel.marshaller.serializers.server.serialize(cachedRawServer);
    }

    final [serverResponse, channelsResponse, membersResponse] = await Future.wait([
      _kernel.dataStore.client.get('/guilds/$id'),
      _kernel.dataStore.client.get('/guilds/$id/channels'),
      _kernel.dataStore.client.get('/guilds/$id/members')
    ]);

    serverResponse.body['channels'] = channelsResponse.body;
    serverResponse.body['members'] = membersResponse.body;

    final server = await _kernel.marshaller.serializers.server.serialize(serverResponse.body);

    await Future.wait([
      _kernel.marshaller.cache.put(id, serverResponse.body),
      ...server.channels.list.values
          .map((channel) => _kernel.marshaller.cache.put(channel.id, channel)),
      ...server.members.list.values
          .map((member) => _kernel.marshaller.cache.put(member.id, member))
    ]);

    return server;
  }

  Future<Role> getRole(Snowflake guildId, Snowflake id) async {
    final cachedRawRole = await _kernel.marshaller.cache.get(id);
    if (cachedRawRole != null) {
      return _kernel.marshaller.serializers.role.serialize(cachedRawRole);
    }

    final response = await _kernel.dataStore.client.get('/guilds/$guildId/roles');
    final roles = await _serializeRolesResponse(response);
    final role = roles.firstWhere((role) => role.id == id);

    await _kernel.marshaller.cache.put(id, role);

    return role;
  }

  Future<List<Role>> getRoles(Snowflake guildId, { bool force = false }) async {
    if (force) {
      final response = await _kernel.dataStore.client.get('/guilds/$guildId/roles');
      final roles = await _serializeRolesResponse(response);

      for (final role in roles) {
        await _kernel.marshaller.cache.put(role.id, role);
      }

      return roles;
    }

    final rowServer = await _kernel.dataStore.server.getServer(guildId);
    return rowServer.roles.list.values.toList();
  }

  Future<List<Role>> _serializeRolesResponse(Response response) {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => List.from(response.body)
          .map((element) => _kernel.marshaller.serializers.channels.serialize(element)),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    } as Future<List<Role>>;
  }

  Future<void> setOwner(Snowflake guildId, Snowflake newOwnerId) async {
  final server = await getServer(guildId);

  final response = await _kernel.dataStore.client.patch(
    '/guilds/$guildId',
    body: {'owner_id': newOwnerId.toString()},
  );

  if (response.statusCode == 200) {
    server.ownerId = newOwnerId;
    await _kernel.marshaller.cache.put(guildId, server);


    await Future.wait([
      ...server.roles.list.values.map((role) => _kernel.marshaller.cache.put(role.id, role)),
      ...server.members.list.values.map((member) => _kernel.marshaller.cache.put(member.id, member))
    ]);
  } else {
    throw HttpException('Failed to set new owner. Status code: ${response.statusCode}');
  }
}

}
