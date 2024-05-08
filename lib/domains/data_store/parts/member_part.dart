import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/application/http/http_client_status.dart';
import 'package:mineral/application/http/response.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';

final class MemberPart implements DataStorePart {
  final DataStore _dataStore;

  HttpClientStatus get status => _dataStore.client.status;

  MemberPart(this._dataStore);

  Future<Member?> getMemberOrNull({required Snowflake guildId, required Snowflake memberId}) async {
    final roles = await _dataStore.server.getRoles(guildId);
    final serverRaw = await _dataStore.marshaller.cache.get(guildId);
    final server = await _dataStore.marshaller.serializers.server.serialize(serverRaw);

    if (server.members.list.containsKey(memberId)) {
      return server.members.list[memberId];
    }

    final response = await _dataStore.client.get('/guilds/$guildId/members/$memberId');
    final member = await switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
          _dataStore.marshaller.serializers.member.serialize({
            ...response.body,
            'guild_roles': roles,
          }),
      int() when status.isError(response.statusCode) => null,
      _ => null,
    };

    if(member == null) {
      return null;
    }

    final rawMember = await _dataStore.marshaller.serializers.member.deserialize(member);
    rawMember['guild'] = server;
    await _dataStore.marshaller.cache.put(memberId, rawMember);

    member.server = await _dataStore.marshaller.serializers.server.serialize(serverRaw);

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
