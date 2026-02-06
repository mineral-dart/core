import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/voice/playback_error.dart';
import 'package:mineral/src/api/server/voice/voice_connection.dart';
import 'package:mineral/src/domains/services/voice/audio/ffmpeg_decoder.dart';
import 'package:mineral/src/domains/services/voice/audio/opus_encoder.dart';

/// Manages audio playback for a voice connection.
///
/// Handles:
/// - Decoding audio files (via FFmpeg)
/// - Encoding to Opus
/// - Frame timing (20ms intervals)
/// - Volume control
/// - Playback state events
final class VoicePlayer {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  final VoiceConnection _connection;

  bool _isPlaying = false;
  bool _isPaused = false;
  double _volume = 1.0;

  StreamSubscription? _playbackSubscription;
  Completer<void>? _playbackCompleter;
  Stopwatch? _stopwatch;
  int _frameCount = 0;

  // Event stream controllers
  final _onStartController = StreamController<void>.broadcast();
  final _onEndController = StreamController<void>.broadcast();
  final _onPauseController = StreamController<void>.broadcast();
  final _onResumeController = StreamController<void>.broadcast();
  final _onErrorController = StreamController<PlaybackError>.broadcast();

  /// Emitted when playback starts.
  Stream<void> get onStart => _onStartController.stream;

  /// Emitted when playback ends (naturally or via stop).
  Stream<void> get onEnd => _onEndController.stream;

  /// Emitted when playback is paused.
  Stream<void> get onPause => _onPauseController.stream;

  /// Emitted when playback is resumed.
  Stream<void> get onResume => _onResumeController.stream;

  /// Emitted when a playback error occurs.
  Stream<PlaybackError> get onError => _onErrorController.stream;

  /// Whether audio is currently playing (including paused state).
  bool get isPlaying => _isPlaying;

  /// Whether playback is currently paused.
  bool get isPaused => _isPaused;

  /// The current volume level (0.0 to 2.0).
  double get volume => _volume;

  VoicePlayer(this._connection);

  /// Plays an audio file.
  ///
  /// The file is decoded to PCM, encoded to Opus, and streamed
  /// at the correct rate (20ms per frame).
  ///
  /// Supported formats: MP3, WAV, OGG, FLAC, and other FFmpeg-supported formats.
  ///
  /// Returns when playback completes or is stopped.
  ///
  /// Throws [PlaybackError] if the file cannot be played.
  Future<void> play(File file) async {
    if (_isPlaying) {
      await stop();
    }

    _isPlaying = true;
    _isPaused = false;
    _frameCount = 0;
    _playbackCompleter = Completer<void>();

    try {
      // Notify Discord we're speaking
      _connection.setSpeaking(true);

      // Initialize Opus encoder
      final opusEncoder = OpusEncoderWrapper();
      await opusEncoder.init();

      // Initialize FFmpeg decoder
      final ffmpegDecoder = FfmpegDecoder();

      // Emit start event
      _onStartController.add(null);
      _logger.trace('Starting playback: ${file.path}');

      // Start timing
      _stopwatch = Stopwatch()..start();

      // Create audio pipeline
      _playbackSubscription = _createAudioPipeline(
        file,
        ffmpegDecoder,
        opusEncoder,
      ).listen(
        (opusFrame) async {
          if (!_isPaused && _isPlaying) {
            await _connection.sendAudio(opusFrame);
          }
        },
        onDone: () {
          _finishPlayback(opusEncoder);
        },
        onError: (error, stack) {
          _handlePlaybackError(error, stack, opusEncoder);
        },
      );

      await _playbackCompleter!.future;
    } catch (e, stack) {
      _handlePlaybackError(e, stack, null);
      rethrow;
    }
  }

  /// Creates the audio processing pipeline.
  Stream<List<int>> _createAudioPipeline(
    File file,
    FfmpegDecoder decoder,
    OpusEncoderWrapper encoder,
  ) async* {
    await for (final pcmFrame in decoder.decode(file)) {
      // Wait for pause to be lifted
      while (_isPaused && _isPlaying) {
        await Future.delayed(const Duration(milliseconds: 50));
      }

      if (!_isPlaying) break;

      // Apply volume adjustment
      final adjustedPcm = _applyVolume(pcmFrame);

      // Encode to Opus
      final opusFrame = encoder.encode(adjustedPcm);

      // Maintain proper timing (20ms per frame)
      await _waitForNextFrame();

      yield opusFrame;
      _frameCount++;
    }
  }

  /// Waits until it's time to send the next frame.
  Future<void> _waitForNextFrame() async {
    final targetTimeMs = _frameCount * 20;
    final elapsedMs = _stopwatch?.elapsedMilliseconds ?? 0;

    if (elapsedMs < targetTimeMs) {
      await Future.delayed(Duration(milliseconds: targetTimeMs - elapsedMs));
    }
  }

  /// Applies volume adjustment to PCM data.
  Uint8List _applyVolume(Uint8List pcmData) {
    if (_volume == 1.0) return pcmData;

    final samples = Int16List.view(pcmData.buffer);
    final adjusted = Int16List(samples.length);

    for (int i = 0; i < samples.length; i++) {
      final sample = (samples[i] * _volume).round();
      adjusted[i] = sample.clamp(-32768, 32767);
    }

    return Uint8List.view(adjusted.buffer);
  }

  /// Finishes playback normally.
  Future<void> _finishPlayback(OpusEncoderWrapper? encoder) async {
    if (!_isPlaying) return;

    _logger.trace('Playback finished');

    // Send silence frames to prevent audio artifacts
    await _sendSilenceFrames();

    _cleanup(encoder);

    // Emit end event
    _onEndController.add(null);

    _playbackCompleter?.complete();
  }

  /// Handles playback errors.
  void _handlePlaybackError(Object error, StackTrace stack, OpusEncoderWrapper? encoder) {
    _logger.error('Playback error: $error');
    _logger.trace(stack.toString());

    _cleanup(encoder);

    final playbackError = error is PlaybackError
        ? error
        : PlaybackError(error.toString(), error);

    _onErrorController.add(playbackError);
    _onEndController.add(null);

    _playbackCompleter?.completeError(playbackError);
  }

  /// Sends silence frames before stopping.
  Future<void> _sendSilenceFrames() async {
    const silenceFrame = [0xF8, 0xFF, 0xFE];
    for (int i = 0; i < 5; i++) {
      await _connection.sendAudio(silenceFrame);
    }
  }

  /// Cleans up playback resources.
  void _cleanup(OpusEncoderWrapper? encoder) {
    _isPlaying = false;
    _isPaused = false;
    _stopwatch?.stop();
    _playbackSubscription?.cancel();
    _playbackSubscription = null;
    encoder?.dispose();
    _connection.setSpeaking(false);
  }

  /// Stops the current playback.
  Future<void> stop() async {
    if (!_isPlaying) return;

    _logger.trace('Stopping playback');
    _isPlaying = false;

    // Send silence frames
    await _sendSilenceFrames();

    _playbackSubscription?.cancel();
    _playbackSubscription = null;

    _connection.setSpeaking(false);

    _onEndController.add(null);

    if (_playbackCompleter != null && !_playbackCompleter!.isCompleted) {
      _playbackCompleter!.complete();
    }
  }

  /// Pauses the current playback.
  void pause() {
    if (!_isPlaying || _isPaused) return;

    _logger.trace('Pausing playback');
    _isPaused = true;
    _stopwatch?.stop();
    _connection.setSpeaking(false);
    _onPauseController.add(null);
  }

  /// Resumes paused playback.
  void resume() {
    if (!_isPlaying || !_isPaused) return;

    _logger.trace('Resuming playback');
    _isPaused = false;
    _stopwatch?.start();
    _connection.setSpeaking(true);
    _onResumeController.add(null);
  }

  /// Sets the volume level.
  ///
  /// [value] should be between 0.0 (mute) and 2.0 (200% volume).
  /// Default is 1.0 (100% volume).
  void setVolume(double value) {
    _volume = value.clamp(0.0, 2.0);
    _logger.trace('Volume set to $_volume');
  }

  /// Disposes of the player and its resources.
  void dispose() {
    stop();
    _onStartController.close();
    _onEndController.close();
    _onPauseController.close();
    _onResumeController.close();
    _onErrorController.close();
  }
}
