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

  /// Get if the [Member] is on a [VoiceChannel].
  bool get isOnVoiceChannel => _voiceState?.channelId != null;

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

  /// Mute the [Member].
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.mute(reason: 'Testing');
  /// ```
  Future<void> mute({String? reason}) async {
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member
        .update(serverId: _serverId, memberId: _memberId, reason: reason, payload: {'mute': true});
  }

  /// Unmute the [Member].
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.unMute(reason: 'Testing');
  /// ```
  Future<void> unMute({String? reason}) async {
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member
        .update(serverId: _serverId, memberId: _memberId, reason: reason, payload: {'mute': false});
  }

  /// Toggle the [Member] mute status.
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.toggleMute(reason: 'Testing');
  /// ```
  Future<void> toggleMute({String? reason}) async {
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member.update(
        serverId: _serverId,
        memberId: _memberId,
        reason: reason,
        payload: {'mute': !(isMuted ?? false)});
  }

  /// Deafen the [Member].
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.deafen(reason: 'Testing');
  /// ```
  Future<void> deafen({String? reason}) async {
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member
        .update(serverId: _serverId, memberId: _memberId, reason: reason, payload: {'deaf': true});
  }

  /// Set the [Member] mute status.
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.setMute(true, reason: 'Testing');
  /// ```
  Future<void> setMute(bool value, {String? reason}) async {
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member
        .update(serverId: _serverId, memberId: _memberId, reason: reason, payload: {'mute': value});
  }

  /// Un-deafen the [Member].
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.unDeafen(reason: 'Testing');
  /// ```
  Future<void> unDeafen({String? reason}) async {
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member
        .update(serverId: _serverId, memberId: _memberId, reason: reason, payload: {'deaf': false});
  }

  /// Toggle the [Member] deafen status.
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.toggleDeafen(reason: 'Testing');
  /// ```
  Future<void> toggleDeafen({String? reason}) async {
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member.update(
        serverId: _serverId,
        memberId: _memberId,
        reason: reason,
        payload: {'deaf': !(isDeafened ?? false)});
  }

  /// Set the [Member] deafen status.
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.setDeafen(true, reason: 'Testing');
  /// ```
  Future<void> setDeafen(bool value, {String? reason}) async {
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member
        .update(serverId: _serverId, memberId: _memberId, reason: reason, payload: {'deaf': value});
  }

  /// Update the current [VoiceState] with multiple properties.
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.update(
  ///   mute: true,
  ///   deafen: true,
  ///   channelId: '1284803626270855197',
  ///   reason: 'Testing'
  /// );
  /// ```
  Future<void> update({
    bool? mute,
    bool? deafen,
    String? channelId,
    String? reason,
  }) async {
    await _datastore.member.update(
      serverId: _serverId,
      memberId: _memberId,
      reason: reason,
      payload: {
        if (mute != null) 'mute': mute,
        if (deafen != null) 'deaf': deafen,
        if (channelId != null) 'channel_id': channelId,
      },
    );
  }

  /// Move the [Member] to a different voice channel.
  /// ```dart
  /// final voice = await member.resolveVoiceContext();
  /// await voice.move('1163041637497307176', reason: 'Testing');
  /// ```
  Future<void> move(String channelId, {String? reason}) async {
    if (_voiceState?.channelId == null) {
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
    if (_voiceState?.channelId == null) {
      _logger.warn('Member is not on a voice channel.');
      return;
    }

    await _datastore.member.update(
        serverId: _serverId, memberId: _memberId, reason: reason, payload: {'channel_id': null});
  }
}
