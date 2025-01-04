import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/voice_state.dart';

final class MemberVoiceManager {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  final Snowflake _serverId;
  final Snowflake _memberId;
  final VoiceState? _voiceState;

  /// Check if the [Member] is on a [ServerVoiceChannel].
  bool get isOnVoiceChannel => _voiceState != null;

  /// Get the [ServerVoiceChannel] ID where the [Member] is.
  bool? get isMuted => _voiceState?.isMute;

  /// Get the [ServerVoiceChannel] ID where the [Member] is.
  bool? get isSelfMuted => _voiceState?.isSelfMute;

  /// Get the [ServerVoiceChannel] ID where the [Member] is.
  bool? get isDeafened => _voiceState?.isDeaf;

  /// Get the [ServerVoiceChannel] ID where the [Member] is.
  bool? get isSelfDeafened => _voiceState?.isSelfDeaf;

  /// Get the [ServerVoiceChannel] ID where the [Member] is.
  bool? get hasSelfVideo => _voiceState?.hasSelfVideo;

  /// Get the [ServerVoiceChannel] ID where the [Member] is.
  bool? get isSuppressed => _voiceState?.isSuppress;

  /// Get the [ServerVoiceChannel] ID where the [Member] is.
  DateTime? get requestToSpeakTimestamp => _voiceState?.requestToSpeakTimestamp;

  MemberVoiceManager(this._serverId, this._memberId, this._voiceState);

  /// Move the [Member] to a different voice channel.
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.move('1163041637497307176', reason: 'Testing');
  /// ```
  Future<void> move(String channelId, {String? reason}) async {
    if (!isOnVoiceChannel) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member.update(
        serverId: _serverId,
        memberId: _memberId,
        reason: reason,
        payload: {'channel_id': channelId});
  }

  /// Disconnect the [Member] from the voice channel.
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.disconnect(reason: 'Testing');
  /// ```
  Future<void> disconnect({String? reason}) async {
    if (!isOnVoiceChannel) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member.update(
        serverId: _serverId, memberId: _memberId, reason: reason, payload: {'channel_id': null});
  }
}
