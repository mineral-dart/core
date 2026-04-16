import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';

final class MemberPart implements MemberPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, Member>> fetch(Object serverId, bool force) async {
    final req = Request.json(endpoint: '/guilds/$serverId/members');
    final result = await _dataStore.requestBucket
        .query<List<Map<String, dynamic>>>(req)
        .run(_dataStore.client.get);

    final members = await result.map((element) async {
      final raw = await _marshaller.serializers.member
          .normalize({...element, 'guild_id': serverId});
      return _marshaller.serializers.member.serialize(raw);
    }).wait;

    return members.asMap().map((_, value) => MapEntry(value.id, value));
  }

  @override
  Future<Member?> get(Object serverId, Object id, bool force) async {
    final String key = _marshaller.cacheKey.member(serverId, id);

    final cachedMember = await _marshaller.cache?.get(key);
    if (!force && cachedMember != null) {
      final member =
          await _marshaller.serializers.member.serialize(cachedMember);

      return member;
    }

    final req = Request.json(endpoint: '/guilds/$serverId/members/$id');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.member
        .normalize({...result, 'guild_id': serverId});
    final member = await _marshaller.serializers.member.serialize(raw);

    return member;
  }

  @override
  Future<Member> update(
      {required Object serverId,
      required Object memberId,
      required Map<String, dynamic> payload,
      String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$serverId/members/$memberId',
        body: payload,
        headers: {DiscordHeader.auditLogReason(reason)});
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.patch);

    final raw = await _marshaller.serializers.member.normalize({
      ...result,
      'guild_id': serverId,
    });
    final member = await _marshaller.serializers.member.serialize(raw);

    return member;
  }

  @override
  Future<void> ban(
      {required Object serverId,
      required Duration? deleteSince,
      required Object memberId,
      String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$serverId/bans/$memberId',
        body: {'delete_message_seconds': deleteSince?.inSeconds},
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.put);
  }

  @override
  Future<void> kick(
      {required Object serverId,
      required Object memberId,
      String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$serverId/members/$memberId',
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }

  @override
  Future<VoiceState?> getVoiceState(
      Object serverId, Object userId, bool force) async {
    final String key = _marshaller.cacheKey.voiceState(serverId, userId);

    final cachedMember = await _marshaller.cache?.get(key);
    if (!force && cachedMember != null) {
      final voiceState =
          await _marshaller.serializers.voice.serialize(cachedMember);

      return voiceState;
    }

    final req =
        Request.json(endpoint: '/guilds/$serverId/voice-states/$userId');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.voice.normalize(result);
    final voice = await _marshaller.serializers.voice.serialize(raw);

    return voice;
  }
}
