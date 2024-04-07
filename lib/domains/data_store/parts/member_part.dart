import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/application/http/http_client_status.dart';
import 'package:mineral/application/http/http_request_option.dart';
import 'package:mineral/application/http/response.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';
import 'package:mineral/domains/http/discord_header.dart';

final class MemberPart implements DataStorePart {
  final DataStore _dataStore;

  HttpClientStatus get status => _dataStore.client.status;

  MemberPart(this._dataStore);

  Future<Member> getMember({required Snowflake guildId, required Snowflake memberId}) async {
    final cachedRawMember = await _dataStore.marshaller.cache.get(memberId);
    final roles = await _dataStore.server.getRoles(guildId);

    if (cachedRawMember != null) {
      return _dataStore.marshaller.serializers.member.serialize({
        ...cachedRawMember,
        'guild_roles': roles,
      });
    }

    final response = await _dataStore.client.get('/guilds/$guildId/members/$memberId');
    final member = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _dataStore.marshaller.serializers.member.serialize({
          ...response.body,
          'guild_roles': roles,
        }),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    final rawMember = await _dataStore.marshaller.serializers.member.deserialize(member);
    await _dataStore.marshaller.cache.put(memberId, rawMember);

    return member;
  }

  Future<List<Member>> getMembers(Snowflake guildId, {bool force = false}) async {
    if (force) {
      final response = await _dataStore.client.get('/guilds/$guildId/members');
      final members = await _serializeMembersResponse(response);

      await Future.wait(members
          .map((member) async => _dataStore.marshaller.serializers.member.deserialize(member)));

      return members;
    }

    final rawServer = await _dataStore.marshaller.cache.get(guildId);
    final roles = await _dataStore.server.getRoles(guildId);
    return Future.wait(List.from(rawServer['members']).map((id) async {
      final rawMember = await _dataStore.marshaller.cache.get(id);
      return _dataStore.marshaller.serializers.member.serialize({
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
    final response = await _dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final member = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _dataStore.marshaller.serializers.member.serialize(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    final rawMember = await _dataStore.marshaller.serializers.member.deserialize(member);
    await _dataStore.marshaller.cache.put(memberId, rawMember);

    return member;
  }

  Future<void> banMember(
      {required Snowflake serverId,
      required Duration? deleteSince,
      required Snowflake memberId,
      String? reason}) async {
    final response = await _dataStore.client.put('/guilds/$serverId/bans/$memberId',
        body: {'delete_message_seconds': deleteSince?.inSeconds},
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isSuccess(response.statusCode)) {
      return;
    }
  }

  Future<List<Member>> _serializeMembersResponse(Response response) {
    final awaitedMembers = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => List.from(response.body)
          .map((element) async => _dataStore.marshaller.serializers.member.serialize(element))
          .toList(),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    return Future.wait(awaitedMembers);
  }
}
