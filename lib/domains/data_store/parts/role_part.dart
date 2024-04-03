import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/application/http/http_client_status.dart';
import 'package:mineral/application/http/http_request_option.dart';
import 'package:mineral/application/http/response.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';
import 'package:mineral/domains/http/discord_header.dart';

final class RolePart implements DataStorePart {
  final DataStore _dataStore;

  HttpClientStatus get status => _dataStore.client.status;

  RolePart(this._dataStore);

  Future<Role?> updateRole(
      {required Snowflake id,
      required Snowflake serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch('/guilds/$serverId/roles/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Role? role = await serializeRoleResponse(response);

    final rawRole = _dataStore.marshaller.serializers.role.deserialize(response.body);
    await _dataStore.marshaller.cache.put(role?.id, rawRole);

    return role;
  }

  Future<void> deleteRole(
      {required Snowflake id, required Snowflake guildId, required String? reason}) async {
    await _dataStore.client.delete('/guilds/$guildId/roles/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<Role?> serializeRoleResponse(Response response) {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _dataStore.marshaller.serializers.role.serialize(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    } as Future<Role?>;
  }
}
