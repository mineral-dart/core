import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:opus_dart/opus_dart.dart';

/// Wrapper around the Opus encoder for Discord voice.
///
/// Discord requires:
/// - Sample rate: 48000 Hz
/// - Channels: 2 (stereo)
/// - Frame size: 960 samples (20ms at 48kHz)
///
/// **Important**: You must have the libopus native library installed on your system.
/// The library is automatically discovered based on platform:
/// - Linux: libopus.so
/// - macOS: libopus.dylib (install via `brew install opus`)
/// - Windows: opus.dll
final class OpusEncoderWrapper {
  static const int sampleRate = 48000;
  static const int channels = 2;
  static const int frameSize = 960; // 20ms at 48kHz
  static const int bytesPerSample = 2; // 16-bit PCM
  static const int frameSizeBytes = frameSize * channels * bytesPerSample;

  late final SimpleOpusEncoder _encoder;
  bool _initialized = false;

  static bool _opusInitialized = false;

  /// Initializes the Opus encoder.
  ///
  /// This will automatically discover the libopus library on the system.
  /// Make sure libopus is installed:
  /// - macOS: `brew install opus`
  /// - Linux: `apt install libopus-dev` or `yum install opus-devel`
  /// - Windows: Download opus.dll and place it in the executable directory
  Future<void> init() async {
    if (_initialized) return;

    // Initialize opus_dart globally (only once)
    if (!_opusInitialized) {
      final libraryPath = _getOpusLibraryPath();
      try {
        initOpus(DynamicLibrary.open(libraryPath));
        _opusInitialized = true;
      } catch (e) {
        throw StateError(
          'Failed to load libopus from "$libraryPath". '
          'Make sure the Opus library is installed on your system.\n'
          'Error: $e',
        );
      }
    }

    _encoder = SimpleOpusEncoder(
      sampleRate: sampleRate,
      channels: channels,
      application: Application.audio,
    );

    _initialized = true;
  }

  /// Gets the platform-specific path to the Opus library.
  static String _getOpusLibraryPath() {
    if (Platform.isLinux) {
      return 'libopus.so.0';
    } else if (Platform.isMacOS) {
      // Try common Homebrew paths
      final homebrewPaths = [
        '/opt/homebrew/lib/libopus.dylib', // Apple Silicon
        '/usr/local/lib/libopus.dylib', // Intel
        'libopus.dylib', // System path
      ];

      for (final path in homebrewPaths) {
        if (File(path).existsSync()) {
          return path;
        }
      }

      return 'libopus.dylib';
    } else if (Platform.isWindows) {
      return 'opus.dll';
    } else {
      throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
    }
  }

  /// Encodes a PCM audio frame to Opus.
  ///
  /// [pcmData] must be 16-bit signed PCM, stereo, 48kHz.
  /// Each frame should be 960 samples * 2 channels * 2 bytes = 3840 bytes.
  ///
  /// Returns the Opus-encoded frame.
  Uint8List encode(Uint8List pcmData) {
    if (!_initialized) {
      throw StateError('Encoder not initialized. Call init() first.');
    }

    // Convert bytes to Int16List for the encoder
    final samples = Int16List.view(pcmData.buffer);

    // Encode to Opus
    final encoded = _encoder.encode(input: samples);

    return Uint8List.fromList(encoded);
  }

  /// Encodes a silence frame.
  ///
  /// Discord uses the specific bytes [0xF8, 0xFF, 0xFE] for Opus silence.
  Uint8List encodeSilence() {
    return Uint8List.fromList([0xF8, 0xFF, 0xFE]);
  }

  /// Disposes of the encoder resources.
  void dispose() {
    if (_initialized) {
      _encoder.destroy();
      _initialized = false;
    }
  }
}
