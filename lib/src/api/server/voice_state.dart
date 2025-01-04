import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/managers/member_voice_manager.dart';

final class VoiceState {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

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

  /// Get the [VoiceState] of the member inside [MemberVoiceManager].
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// ```
  ///
  /// You can `force` the update by setting the `force` parameter to `true` to override [CacheProviderContract] by the Discord APi Response.
  /// ```dart
  /// final voice = await member.resolveVoiceContext(force: true);
  /// ```
  Future<MemberVoiceManager> resolveVoiceContext({bool force = false}) async {
    final voiceState = await _datastore.member.getVoiceState(serverId.value, userId.value, force);
    return MemberVoiceManager(serverId, userId, voiceState);
  }
}
