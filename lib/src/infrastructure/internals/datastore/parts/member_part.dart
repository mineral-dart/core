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
  Future<Member> get(String serverId, String memberId, bool force) async {
    final completer = Completer<Member>();
    final String key = _marshaller.cacheKey.member(serverId, memberId);

    final cachedChannel = await _marshaller.cache.get(key);
    if (!force && cachedChannel != null) {
      final member = await _marshaller.serializers.member.serialize(cachedChannel);
      completer.complete(member);

      return completer.future;
    }

    final response = await _dataStore.client.get('/guilds/$serverId/members/$memberId');
    final member = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.member.normalize({
          ...response.body,
          'server_id': response.body['guild_id'],
        }),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.member.serialize(member));

    return completer.future;
  }

  @override
  Future<List<Member>> getMembers(Snowflake guildId, {bool force = false}) async {
    final serverCacheKey = _marshaller.cacheKey.server(guildId.value);
    final rawServer = await _marshaller.cache.getOrFail(serverCacheKey);

    final rawMemberIds = List<String>.from(rawServer['members']);
    final rawCachedMembers = await _marshaller.cache.getMany(rawMemberIds);
    if (rawMemberIds.length == rawCachedMembers.length) {
      return Future.wait(rawCachedMembers.nonNulls
          .map((element) async => _marshaller.serializers.member.serialize(element))
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
    final response = await _dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final rawMember = await _marshaller.serializers.member.normalize(response.body);
    return _marshaller.serializers.member.serialize(rawMember);
  }

  @override
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

  @override
  Future<void> kickMember(
      {required Snowflake serverId, required Snowflake memberId, String? reason}) async {
    final response = await _dataStore.client.delete('/guilds/$serverId/members/$memberId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    if (status.isSuccess(response.statusCode)) {
      return;
    }
  }
}
