import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/application/http/http_client_status.dart';
import 'package:mineral/application/http/response.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';

final class MemberPart implements DataStorePart {
  final DataStore _dataStore;

  HttpClientStatus get status => _dataStore.client.status;

  MemberPart(this._dataStore);

  Future<Member> getMember(Snowflake guildId, Snowflake id) async {
    final cachedRawMember = await _dataStore.marshaller.cache.get(id);
    if (cachedRawMember != null) {
      return _dataStore.marshaller.serializers.member.serialize(cachedRawMember);
    }

    final response = await _dataStore.client.get('/guilds/$guildId/members/$id');
    final member = await _serializeMemberResponse(response);

    await _dataStore.marshaller.cache.put(id, member);

    return member!;
  }

  Future<Member?> _serializeMemberResponse(Response response) {
    return switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        _dataStore.marshaller.serializers.member.serialize(response.body),
      int() when status.isError(response.statusCode) => throw HttpException(response.body),
      _ => throw Exception('Unknown status code: ${response.statusCode}'),
    } as Future<Member?>;
  }
}
