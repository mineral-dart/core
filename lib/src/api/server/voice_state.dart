import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/managers/member_voice_manager.dart';

final class VoiceState {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  final Snowflake serverId;
  final Snowflake? channelId;
  final Snowflake userId;
  final String? sessionId;
  final bool isDeaf;
  final bool isMute;
  final bool isSelfDeaf;
  final bool isSelfMute;
  final bool hasSelfVideo;
  final bool isSuppress;
  final DateTime? requestToSpeakTimestamp;
  final bool isDiscoverable;

  VoiceState({
    required this.serverId,
    required this.channelId,
    required this.userId,
    required this.sessionId,
    required this.isDeaf,
    required this.isMute,
    required this.isSelfDeaf,
    required this.isSelfMute,
    required this.hasSelfVideo,
    required this.isSuppress,
    required this.requestToSpeakTimestamp,
    required this.isDiscoverable,
  });

  /// Get related [User]
  /// ```dart
  /// final user = await voiceState.resolveUser();
  /// ```
  Future<User> resolveUser() async {
    final user = await _datastore.user.get(userId.value, true);
    return user!;
  }

  /// Get related [Member]
  /// ```dart
  /// final member = await voiceState.resolveMember();
  /// ```
  Future<Member?> resolveMember() => _datastore.member.get(serverId.value, userId.value, true);

  /// Get related [ServerVoiceChannel]
  /// ```dart
  /// final channel = await voiceState.resolveChannel();
  /// ```
  Future<ServerVoiceChannel?> resolveChannel() async {
    return switch(channelId) {
      Snowflake(:final value) => await _datastore.channel.get(value, true),
      _ => null,
    };
  }

  /// Get related [MemberVoiceManager]
  /// ```dart
  /// final voice = await voiceState.resolveVoiceContext();
  /// ```
  Future<MemberVoiceManager> resolveVoiceContext() async {
    final cacheKey = _marshaller.cacheKey.voiceState(serverId.value, userId.value);
    final raw = await _marshaller.cache?.get(cacheKey);
    final voiceState = raw != null ? await _marshaller.serializers.voice.serialize(raw) : null;

    return MemberVoiceManager(serverId, userId, voiceState);
  }
}
