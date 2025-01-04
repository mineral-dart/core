import 'dart:async';
import 'dart:io';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class MemberPart implements MemberPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, Member>> fetch(String serverId, bool force) async {
    final completer = Completer<Map<Snowflake, Member>>();
    final response = await _dataStore.client.get('/guilds/$serverId/members');

    final rawMembers = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => await Future.wait(
          List.from(response.body).map((element) async =>
              await _marshaller.serializers.member.normalize({...element, 'guild_id': serverId})),
        ),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    };

    final members = await Future.wait(rawMembers.map((element) async {
      return _marshaller.serializers.member.serialize(element);
    }));

    completer.complete(members.asMap().map((_, value) => MapEntry(value.id, value)));
    return completer.future;
  }

  @override
  Future<Member?> get(String serverId, String id, bool force) async {
    final completer = Completer<Member>();
    final String key = _marshaller.cacheKey.member(serverId, id);

    final cachedMember = await _marshaller.cache?.get(key);
    if (!force && cachedMember != null) {
      final member = await _marshaller.serializers.member.serialize(cachedMember);
      completer.complete(member);

      return completer.future;
    }

    final response = await _dataStore.client.get('/guilds/$serverId/members/$id');
    final role = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.member.normalize({...response.body, 'guild_id': serverId}),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.member.serialize(role));
    return completer.future;
  }

  @override
  Future<Member> update(
      {required Snowflake serverId,
      required Snowflake memberId,
      required Map<String, dynamic> payload,
      String? reason}) async {
    final completer = Completer<Member>();

    final response = await _dataStore.client.patch('/guilds/$serverId/members/$memberId',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final member = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.member.normalize({...response.body, 'guild_id': serverId}),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.member.serialize(member));
    return completer.future;
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

  @override
  Future<VoiceState?> getVoiceState(String serverId, String userId, bool force) async {
    final completer = Completer<VoiceState?>();
    final String key = _marshaller.cacheKey.voiceState(serverId, userId);

    final cachedMember = await _marshaller.cache?.get(key);
    if (!force && cachedMember != null) {
      final voiceState = await _marshaller.serializers.voice.serialize(cachedMember);
      completer.complete(voiceState);

      return completer.future;
    }

    final response = await _dataStore.client.get('/guilds/$serverId/voice-states/$userId');
    final voiceState = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.voice.normalize({...response.body, 'guild_id': serverId}),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => null,
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    if (voiceState == null) {
      completer.complete(null);
      return completer.future;
    }

    completer.complete(await _marshaller.serializers.voice.serialize(voiceState));
    return completer.future;
  }
}
