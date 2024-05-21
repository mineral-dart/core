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

  Future<Member?> getMemberOrNull({required Snowflake guildId, required Snowflake memberId}) async {
    final roles = await _kernel.dataStore.server.getRoles(guildId);
    final serverRaw = await _kernel.marshaller.cache.getOrFail(guildId);
    final server = await _kernel.marshaller.serializers.server.serialize(serverRaw);

    if (server.members.list.containsKey(memberId)) {
      return server.members.list[memberId];
    }

    final response = await _kernel.dataStore.client.get('/guilds/$guildId/members/$memberId');
    final member = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
          _kernel.marshaller.serializers.member.serialize({
            ...response.body,
            'guild_roles': roles,
          }),
      int() when status.isError(response.statusCode) => null,
      _ => null,
    };

    if(member == null) {
      return null;
    }

    final rawMember = await _kernel.marshaller.serializers.member.deserialize(member);
    rawMember['guild'] = server;
    await _kernel.marshaller.cache.put(memberId, rawMember);

    member.server = await _kernel.marshaller.serializers.server.serialize(serverRaw);

    return member;
  }

  Future<Member> getMemberOrFail({required Snowflake guildId, required Snowflake memberId}) async {
    final member = await getMemberOrNull(guildId: guildId, memberId: memberId);
    if (member == null) {
      throw Exception('Member not found');
    }

    return member;
  }

  Future<List<Member>> getMembers(Snowflake guildId, {bool force = false}) async {
    if (force) {
      final response = await _kernel.dataStore.client.get('/guilds/$guildId/members');
      final members = await _serializeMembersResponse(response);

      await Future.wait(members
          .map((member) async => _kernel.marshaller.serializers.member.deserialize(member)));

      return members;
    }

    final rawServer = await _kernel.marshaller.cache.getOrFail(guildId);
    final roles = await _kernel.dataStore.server.getRoles(guildId);

    return Future.wait(List.from(rawServer['members']).map((id) async {
      final rawMember = await _kernel.marshaller.cache.getOrFail(Snowflake(id));
      return _kernel.marshaller.serializers.member.serialize({
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

    print(response.bodyString);

    final member = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _kernel.marshaller.serializers.member.serialize(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    final rawMember = await _kernel.marshaller.serializers.member.deserialize(member);
    await _kernel.marshaller.cache.put(memberId, rawMember);

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
          .map((element) async => _kernel.marshaller.serializers.member.serialize(element))
          .toList(),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    };

    return Future.wait(awaitedMembers);
  }
}
