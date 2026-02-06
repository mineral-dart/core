import 'dart:async';
import 'dart:io';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/voice/playback_error.dart';
import 'package:mineral/src/api/server/voice/voice_connection.dart';
import 'package:mineral/src/api/server/voice/voice_connection_state.dart';
import 'package:mineral/src/api/server/voice/voice_player.dart';
import 'package:mineral/src/infrastructure/internals/voice/voice_connection_manager.dart';

/// Context object for interacting with a voice channel connection.
///
/// Returned by [ServerVoiceChannel.join()], this object provides methods
/// for audio playback and connection management.
///
/// Example:
/// ```dart
/// final channel = await server.channels.get<ServerVoiceChannel>('123456');
/// final voice = await channel.join();
///
/// // Play an MP3 file
/// await voice.play(File('music/song.mp3'));
///
/// // Adjust volume
/// voice.setVolume(0.5);
///
/// // Listen to events
/// voice.onEnd.listen((_) => print('Playback ended'));
///
/// // Disconnect when done
/// await voice.disconnect();
/// ```
final class VoiceContext {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  final Snowflake serverId;
  final Snowflake channelId;
  final VoiceConnection _connection;
  late final VoicePlayer _player;

  /// The current connection state.
  VoiceConnectionState get state => _connection.state;

  /// Whether the connection is ready for audio playback.
  bool get isConnected => state == VoiceConnectionState.ready;

  /// Whether audio is currently playing.
  bool get isPlaying => _player.isPlaying;

  /// Whether playback is currently paused.
  bool get isPaused => _player.isPaused;

  /// The current volume level (0.0 to 2.0).
  double get volume => _player.volume;

  // Playback event streams

  /// Emitted when playback starts.
  Stream<void> get onStart => _player.onStart;

  /// Emitted when playback ends (naturally or via stop).
  Stream<void> get onEnd => _player.onEnd;

  /// Emitted when playback is paused.
  Stream<void> get onPause => _player.onPause;

  /// Emitted when playback is resumed.
  Stream<void> get onResume => _player.onResume;

  /// Emitted when a playback error occurs.
  Stream<PlaybackError> get onError => _player.onError;

  VoiceContext._({
    required this.serverId,
    required this.channelId,
    required VoiceConnection connection,
  }) : _connection = connection {
    _player = VoicePlayer(_connection);
  }

  /// Creates a new VoiceContext.
  ///
  /// This is an internal factory used by [VoiceConnectionManager].
  factory VoiceContext.create({
    required Snowflake serverId,
    required Snowflake channelId,
    required VoiceConnection connection,
  }) {
    return VoiceContext._(
      serverId: serverId,
      channelId: channelId,
      connection: connection,
    );
  }

  /// Plays an audio file through the voice channel.
  ///
  /// Supported formats: MP3, WAV, OGG, FLAC, and other FFmpeg-supported formats.
  ///
  /// **Requires FFmpeg to be installed on the system.**
  ///
  /// Example:
  /// ```dart
  /// await voiceCtx.play(File('music/song.mp3'));
  /// ```
  ///
  /// This method returns when playback completes or is stopped.
  /// Use the event streams to react to playback state changes.
  ///
  /// Throws [ArgumentError] if the file doesn't exist.
  /// Throws [StateError] if not connected to the voice channel.
  /// Throws [PlaybackError] if playback fails.
  Future<void> play(File file) async {
    if (!file.existsSync()) {
      throw ArgumentError('File does not exist: ${file.path}');
    }

    if (!isConnected) {
      throw StateError('Not connected to voice channel');
    }

    await _player.play(file);
  }

  /// Stops the current playback.
  ///
  /// If nothing is playing, this method does nothing.
  Future<void> stop() => _player.stop();

  /// Pauses the current playback.
  ///
  /// Call [resume] to continue playback.
  void pause() => _player.pause();

  /// Resumes paused playback.
  void resume() => _player.resume();

  /// Sets the playback volume.
  ///
  /// [value] should be between 0.0 (mute) and 2.0 (200% volume).
  /// Default is 1.0 (100% volume).
  ///
  /// Example:
  /// ```dart
  /// voice.setVolume(0.5);  // 50% volume
  /// voice.setVolume(1.5);  // 150% volume
  /// ```
  void setVolume(double value) => _player.setVolume(value);

  /// Disconnects from the voice channel.
  ///
  /// This stops any current playback and closes the connection.
  /// After disconnecting, this VoiceContext should not be used again.
  ///
  /// Example:
  /// ```dart
  /// await voice.disconnect();
  /// ```
  Future<void> disconnect() async {
    _player.dispose();
    await _connection.disconnect();

    // Notify the connection manager
    final manager = ioc.resolve<VoiceConnectionManager>();
    await manager.disconnect(serverId);
  }

  /// Resolves the voice channel this context is connected to.
  ///
  /// Example:
  /// ```dart
  /// final channel = await voiceCtx.resolveChannel();
  /// print('Connected to: ${channel.name}');
  /// ```
  Future<ServerVoiceChannel> resolveChannel() async {
    final channel = await _dataStore.channel.get<ServerVoiceChannel>(
      channelId.value,
      false,
    );
    return channel!;
  }

  /// Resolves the server this context is connected to.
  ///
  /// Example:
  /// ```dart
  /// final server = await voiceCtx.resolveServer();
  /// print('Server: ${server.name}');
  /// ```
  Future<Server> resolveServer() async {
    return await _dataStore.server.get(serverId.value, false);
  }
}
