import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';

final class RolePart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  RolePart(this._kernel);

  Future<Role> getRole(
      {required Snowflake serverId, required Snowflake roleId}) async {
    final cacheKey = _kernel.marshaller.cacheKey.serverRole(serverId, roleId);
    final rawRole = await _kernel.marshaller.cache.get(cacheKey);

    if (rawRole != null) {
      return _kernel.marshaller.serializers.role.serialize(rawRole);
    }

    final response =
        await _kernel.dataStore.client.get('/guilds/$serverId/roles/$roleId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final payload =
        await _kernel.marshaller.serializers.role.normalize(response.body);
    return _kernel.marshaller.serializers.role.serialize(payload);
  }

  Future<void> addRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason}) async {
    await _kernel.dataStore.client.put(
        '/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<void> removeRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason}) async {
    await _kernel.dataStore.client.delete(
        '/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<void> syncRoles(
      {required Snowflake memberId,
      required Snowflake serverId,
      required List<Snowflake> roleIds,
      required String? reason}) async {
    await _kernel.dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: {'roles': roleIds},
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<Role?> updateRole(
      {required Snowflake id,
      required Snowflake serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _kernel.dataStore.client.patch(
        '/guilds/$serverId/roles/$id',
        body: payload,
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final body =
        await _kernel.marshaller.serializers.role.normalize(response.body);
    return _kernel.marshaller.serializers.role.serialize(body);
  }

  Future<void> deleteRole(
      {required Snowflake id,
      required Snowflake guildId,
      required String? reason}) async {
    await _kernel.dataStore.client.delete('/guilds/$guildId/roles/$id',
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));
  }
}
