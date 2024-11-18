import 'dart:async';
import 'dart:io';

import 'package:mineral/container.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class RolePart implements DataStorePart {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  Future<Role> getRole(
      {required Snowflake serverId, required Snowflake roleId}) async {
    final cacheKey = _marshaller.cacheKey.serverRole(serverId, roleId);
    final rawRole = await _marshaller.cache.get(cacheKey);

    if (rawRole != null) {
      return _marshaller.serializers.role.serialize(rawRole);
    }

    final response =
        await _dataStore.client.get('/guilds/$serverId/roles/$roleId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final payload = await _marshaller.serializers.role.normalize(response.body);
    return _marshaller.serializers.role.serialize(payload);
  }

  Future<void> addRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason}) async {
    await _dataStore.client.put(
        '/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<void> removeRole(
      {required Snowflake memberId,
      required Snowflake serverId,
      required Snowflake roleId,
      required String? reason}) async {
    await _dataStore.client.delete(
        '/guilds/$serverId/members/$memberId/roles/$roleId',
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<void> syncRoles(
      {required Snowflake memberId,
      required Snowflake serverId,
      required List<Snowflake> roleIds,
      required String? reason}) async {
    await _dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: {'roles': roleIds},
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));
  }

  Future<Role?> updateRole(
      {required Snowflake id,
      required Snowflake serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch(
        '/guilds/$serverId/roles/$id',
        body: payload,
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final body = await _marshaller.serializers.role.normalize(response.body);
    return _marshaller.serializers.role.serialize(body);
  }

  Future<void> deleteRole(
      {required Snowflake id,
      required Snowflake guildId,
      required String? reason}) async {
    await _dataStore.client.delete('/guilds/$guildId/roles/$id',
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));
  }
}
