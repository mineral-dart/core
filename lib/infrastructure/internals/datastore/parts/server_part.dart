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
    if (await _kernel.marshaller.cache.has(id.value)) {
      return _kernel.marshaller.serializers.server.serializeCache({ 'id': id.value });
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
      _kernel.marshaller.cache.put(id.value, serverResponse.body),
      ...server.channels.list.values
          .map((channel) => _kernel.marshaller.cache.put(channel.id.value, channel)),
      ...server.members.list.values
          .map((member) => _kernel.marshaller.cache.put(member.id.value, member))
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

    await _kernel.marshaller.cache.put(id.value, role);

    return role;
  }

  Future<List<Role>> getRoles(Snowflake guildId, { bool force = false }) async {
    if (force) {
      final response = await _kernel.dataStore.client.get('/guilds/$guildId/roles');
      final roles = await _serializeRolesResponse(response);

      for (final role in roles) {
        await _kernel.marshaller.cache.put(role.id.value, role);
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
