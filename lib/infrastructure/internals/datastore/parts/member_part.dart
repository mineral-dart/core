import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';
import 'package:mineral/infrastructure/services/http/response.dart';

final class MemberPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  MemberPart(this._kernel);

  Future<Member> getMember({required Snowflake guildId, required Snowflake memberId}) async {
    final cacheKeys = _kernel.marshaller.cacheKey;
    final memberCacheKey = cacheKeys.serverMember(serverId: guildId, memberId: memberId);

    final cachedRawMember = await _kernel.marshaller.cache.get(memberCacheKey);
    final roles = await _kernel.dataStore.server.getRoles(guildId);

    if (cachedRawMember != null) {
      return _kernel.marshaller.serializers.member.serializeRemote({
        ...cachedRawMember,
        'guild_roles': roles,
      });
    }

    final response = await _kernel.dataStore.client.get('/guilds/$guildId/members/$memberId');
    final member = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _kernel.marshaller.serializers.member.serializeRemote({
          ...response.body,
          'guild_roles': roles,
        }),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    final rawMember = await _kernel.marshaller.serializers.member.deserialize(member);
    await _kernel.marshaller.cache.put(memberId.value, rawMember);

    return member;
  }

  Future<List<Member>> getMembers(Snowflake guildId, {bool force = false}) async {
    if (force) {
      final response = await _kernel.dataStore.client.get('/guilds/$guildId/members');
      final members = await _serializeMembersResponse(response);

      await Future.wait(
          members.map((member) async => _kernel.marshaller.serializers.member.deserialize(member)));

      return members;
    }

    final rawServer = await _kernel.marshaller.cache.getOrFail(guildId.value);
    final roles = await _kernel.dataStore.server.getRoles(guildId);

    return Future.wait(List.from(rawServer['members']).map((id) async {
      final rawMember = await _kernel.marshaller.cache.getOrFail(id);
      return _kernel.marshaller.serializers.member.serializeRemote({
        ...rawMember,
        'guild_roles': roles,
      });
    }));
  }

  Future<Member> updateMember(
      {required Snowflake serverId,
      required Snowflake memberId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _kernel.dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final member = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _kernel.marshaller.serializers.member.serializeRemote(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    final rawMember = await _kernel.marshaller.serializers.member.deserialize(member);
    await _kernel.marshaller.cache.put(memberId.value, rawMember);

    return member;
  }

  Future<void> banMember(
      {required Snowflake serverId,
      required Duration? deleteSince,
      required Snowflake memberId,
      String? reason}) async {
    final response = await _kernel.dataStore.client.put('/guilds/$serverId/bans/$memberId',
        body: {'delete_message_seconds': deleteSince?.inSeconds},
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isSuccess(response.statusCode)) {
      return;
    }
  }

  Future<void> kickMember(
      {required Snowflake serverId, required Snowflake memberId, String? reason}) async {
    final response = await _kernel.dataStore.client.delete('/guilds/$serverId/members/$memberId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isSuccess(response.statusCode)) {
      return;
    }
  }

  Future<List<Member>> _serializeMembersResponse(Response response) {
    final awaitedMembers = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => List.from(response.body)
          .map((element) async => _kernel.marshaller.serializers.member.serializeRemote(element))
          .toList(),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    return Future.wait(awaitedMembers);
  }
}
