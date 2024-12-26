import 'dart:async';
import 'dart:io';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class MemberPart implements MemberPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Member> getMember(
      {required Snowflake serverId, required Snowflake memberId}) async {

    final cacheKeys = _marshaller.cacheKey;
    final memberCacheKey = cacheKeys.member(serverId, memberId);

    Map<String, dynamic>? cachedRawMember =
        await _marshaller.cache.get(memberCacheKey);

    if (cachedRawMember != null) {
      return _marshaller.serializers.member.serialize(cachedRawMember);
    }

    final response =
        await _dataStore.client.get('/guilds/$serverId/members/$memberId');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    await _marshaller.serializers.member.normalize(response.body);

    cachedRawMember = await _marshaller.cache.getOrFail(memberCacheKey);

    return _marshaller.serializers.member.serialize(cachedRawMember);
  }

  @override
  Future<List<Member>> getMembers(Snowflake guildId,
      {bool force = false}) async {
    final serverCacheKey = _marshaller.cacheKey.server(guildId);
    final rawServer = await _marshaller.cache.getOrFail(serverCacheKey);

    final rawMemberIds = List<String>.from(rawServer['members']);
    final rawCachedMembers = await _marshaller.cache.getMany(rawMemberIds);
    if (rawMemberIds.length == rawCachedMembers.length) {
      return Future.wait(rawCachedMembers.nonNulls
          .map((element) async =>
              _marshaller.serializers.member.serialize(element))
          .toList());
    }

    final response = await _dataStore.client.get('/guilds/$guildId/members');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    return List.from(response.body).map((id) async {
      final payload = await _marshaller.serializers.member.normalize(id);
      return _marshaller.serializers.member.serialize(payload);
    }).wait;
  }

  @override
  Future<Member> updateMember(
      {required Snowflake serverId,
      required Snowflake memberId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final response = await _dataStore.client.patch(
        '/guilds/$serverId/members/$memberId',
        body: payload,
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final rawMember =
        await _marshaller.serializers.member.normalize(response.body);
    return _marshaller.serializers.member.serialize(rawMember);
  }

  @override
  Future<void> banMember(
      {required Snowflake serverId,
      required Duration? deleteSince,
      required Snowflake memberId,
      String? reason}) async {
    final response = await _dataStore.client.put(
        '/guilds/$serverId/bans/$memberId',
        body: {'delete_message_seconds': deleteSince?.inSeconds},
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isSuccess(response.statusCode)) {
      return;
    }
  }

  @override
  Future<void> kickMember(
      {required Snowflake serverId,
      required Snowflake memberId,
      String? reason}) async {
    final response = await _dataStore.client.delete(
        '/guilds/$serverId/members/$memberId',
        option: HttpRequestOptionImpl(
            headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isSuccess(response.statusCode)) {
      return;
    }
  }
}
