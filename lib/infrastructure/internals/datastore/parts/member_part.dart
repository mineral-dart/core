import 'dart:async';
import 'dart:io';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client_status.dart';
import 'package:mineral/infrastructure/services/http/http_request_option.dart';

final class MemberPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  MemberPart(this._kernel);

  Future<Member> getMember({required Snowflake guildId, required Snowflake memberId}) async {
    final cacheKeys = _kernel.marshaller.cacheKey;
    final memberCacheKey = cacheKeys.member(guildId, memberId);

    Map<String, dynamic>? cachedRawMember = await _kernel.marshaller.cache.get(memberCacheKey);

    if (cachedRawMember != null) {
      return _kernel.marshaller.serializers.member.serialize(cachedRawMember);
    }

    final response = await _kernel.dataStore.client.get('/guilds/$guildId/members/$memberId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    await _kernel.marshaller.serializers.member.normalize(response.body);

    cachedRawMember = await _kernel.marshaller.cache.getOrFail(memberCacheKey);

    return _kernel.marshaller.serializers.member.serialize(cachedRawMember);
  }

  Future<List<Member>> getMembers(Snowflake guildId, {bool force = false}) async {
    final serverCacheKey = _kernel.marshaller.cacheKey.server(guildId);
    final rawServer = await _kernel.marshaller.cache.getOrFail(serverCacheKey);

    final rawMemberIds = List<String>.from(rawServer['members']);
    final rawCachedMembers = await _kernel.marshaller.cache.getMany(rawMemberIds);
    if (rawMemberIds.length == rawCachedMembers.length) {
      return Future.wait(rawCachedMembers.nonNulls
          .map((element) async => _kernel.marshaller.serializers.member.serialize(element))
          .toList());
    }

    final response = await _kernel.dataStore.client.get('/guilds/$guildId/members');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    return List.from(response.body).map((id) async {
      final payload = await _kernel.marshaller.serializers.member.normalize(id);
      return _kernel.marshaller.serializers.member.serialize(payload);
    }).wait;
  }

  Future<Member> updateMember(
      {required Snowflake serverId,
      required Snowflake memberId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _kernel.dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final rawMember = await _kernel.marshaller.serializers.member.normalize(response.body);
    return _kernel.marshaller.serializers.member.serialize(rawMember);
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
}
