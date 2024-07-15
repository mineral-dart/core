import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';
import 'package:mineral/infrastructure/services/http/response.dart';

final class RolePart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  RolePart(this._kernel);

  Future<void> addRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason}) async {
    await _kernel.dataStore.client.put('/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<void> removeRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason}) async {
    await _kernel.dataStore.client.delete('/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<void> syncRoles(
      {required Snowflake memberId,
      required Snowflake serverId,
      required List<Snowflake> roleIds,
      required String? reason}) async {
    await _kernel.dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: {'roles': roleIds},
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<Role?> updateRole(
      {required Snowflake id,
      required Snowflake serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _kernel.dataStore.client.patch('/guilds/$serverId/roles/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final Role? role = await serializeRoleResponse(response);

    if (role != null) {
      final rawRole = _kernel.marshaller.serializers.role.deserialize(response.body);
      await _kernel.marshaller.cache.put(role.id.value, rawRole);
    }

    return role;
  }

  Future<void> deleteRole(
      {required Snowflake id, required Snowflake guildId, required String? reason}) async {
    await _kernel.dataStore.client.delete('/guilds/$guildId/roles/$id',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<Role?> serializeRoleResponse(Response response) {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _kernel.marshaller.serializers.role.serializeRemote(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    } as Future<Role?>;
  }
}
