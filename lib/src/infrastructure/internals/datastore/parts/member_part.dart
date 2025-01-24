import 'dart:async';

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
  Future<Map<Snowflake, Member>> fetch(Object serverId, bool force) async {
    final completer = Completer<Map<Snowflake, Member>>();

    final result = await _dataStore.requestBucket
        .run<List>(() => _dataStore.client.get('/guilds/$serverId/members'));

    final members = await result.map((element) async {
      final raw =
          await _marshaller.serializers.member.normalize({...element, 'guild_id': serverId});
      return _marshaller.serializers.member.serialize(raw);
    }).wait;

    completer.complete(members.asMap().map((_, value) => MapEntry(value.id, value)));
    return completer.future;
  }

  @override
  Future<Member?> get(Object serverId, Object id, bool force) async {
    final completer = Completer<Member>();
    final String key = _marshaller.cacheKey.member(serverId, id);

    final cachedMember = await _marshaller.cache?.get(key);
    if (!force && cachedMember != null) {
      final member = await _marshaller.serializers.member.serialize(cachedMember);

      completer.complete(member);
      return completer.future;
    }

    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.get('/guilds/$serverId/members/$id'));

    final raw = await _marshaller.serializers.member.normalize({...result, 'guild_id': serverId});
    final member = await _marshaller.serializers.member.serialize(raw);

    completer.complete(member);
    return completer.future;
  }

  @override
  Future<Member> update(
      {required Object serverId,
      required Object memberId,
      required Map<String, dynamic> payload,
      String? reason}) async {
    final completer = Completer<Member>();

    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client
        .patch('/guilds/$serverId/members/$memberId',
            body: payload,
            option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));

    final raw = await _marshaller.serializers.member.normalize(result);
    final member = await _marshaller.serializers.member.serialize({
      ...raw,
      'guild_id': serverId,
    });

    completer.complete(member);
    return completer.future;
  }

  @override
  Future<void> ban(
      {required Object serverId,
      required Duration? deleteSince,
      required Object memberId,
      String? reason}) async {
    await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client.put(
        '/guilds/$serverId/bans/$memberId',
        body: {'delete_message_seconds': deleteSince?.inSeconds},
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));
  }

  @override
  Future<void> kick({required Object serverId, required Object memberId, String? reason}) async {
    await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client.delete(
        '/guilds/$serverId/members/$memberId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));
  }

  @override
  Future<VoiceState?> getVoiceState(Object serverId, Object userId, bool force) async {
    final completer = Completer<VoiceState?>();
    final String key = _marshaller.cacheKey.voiceState(serverId, userId);

    final cachedMember = await _marshaller.cache?.get(key);
    if (!force && cachedMember != null) {
      final voiceState = await _marshaller.serializers.voice.serialize(cachedMember);

      completer.complete(voiceState);
      return completer.future;
    }

    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(
        () => _dataStore.client.get('/guilds/$serverId/voice-states/$userId'));

    final raw = await _marshaller.serializers.voice.normalize(result);
    final voice = await _marshaller.serializers.voice.serialize(raw);

    completer.complete(voice);
    return completer.future;
  }
}
