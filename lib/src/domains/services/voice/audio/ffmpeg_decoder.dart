import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

/// Decodes audio files (MP3, etc.) to raw PCM using FFmpeg.
///
/// Output format:
/// - Sample rate: 48000 Hz
/// - Channels: 2 (stereo)
/// - Format: signed 16-bit little-endian PCM (s16le)
final class FfmpegDecoder {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  static const int sampleRate = 48000;
  static const int channels = 2;
  static const int frameSize = 960; // 20ms at 48kHz
  static const int bytesPerSample = 2;
  static const int frameSizeBytes = frameSize * channels * bytesPerSample; // 3840 bytes

  /// Decodes an audio file to a stream of PCM frames.
  ///
  /// Each frame is exactly [frameSizeBytes] bytes (3840 bytes = 20ms of audio).
  ///
  /// Throws [FfmpegException] if FFmpeg is not installed or fails.
  Stream<Uint8List> decode(File file) async* {
    if (!file.existsSync()) {
      throw FfmpegException('File does not exist: ${file.path}');
    }

    // Check if ffmpeg is available
    final ffmpegPath = await _findFfmpeg();
    if (ffmpegPath == null) {
      throw FfmpegException(
        'FFmpeg not found. Please install FFmpeg and ensure it is in your PATH.',
      );
    }

    _logger.trace('Decoding audio file: ${file.path}');

    // Run FFmpeg to decode the file to raw PCM
    // Output: signed 16-bit little-endian PCM, 48kHz, stereo
    final process = await Process.start(
      ffmpegPath,
      [
        '-i', file.path,          // Input file
        '-f', 's16le',            // Output format: signed 16-bit little-endian
        '-ar', '$sampleRate',     // Sample rate: 48000
        '-ac', '$channels',       // Channels: 2 (stereo)
        '-loglevel', 'error',     // Only show errors
        'pipe:1',                 // Output to stdout
      ],
    );

    // Buffer for accumulating PCM data
    final buffer = BytesBuilder();

    await for (final chunk in process.stdout) {
      buffer.add(chunk);

      // Yield complete frames
      while (buffer.length >= frameSizeBytes) {
        final bytes = buffer.takeBytes();
        final frame = Uint8List.fromList(bytes.sublist(0, frameSizeBytes));

        // Put remaining bytes back in buffer
        if (bytes.length > frameSizeBytes) {
          buffer.add(bytes.sublist(frameSizeBytes));
        }

        yield frame;
      }
    }

    // Handle any remaining partial frame (pad with silence)
    if (buffer.length > 0) {
      final remaining = buffer.takeBytes();
      final frame = Uint8List(frameSizeBytes);
      frame.setRange(0, remaining.length, remaining);
      // Rest is already zero-filled (silence)
      yield frame;
    }

    // Wait for process to complete
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      final stderr = await process.stderr.transform(const SystemEncoding().decoder).join();
      throw FfmpegException('FFmpeg exited with code $exitCode: $stderr');
    }

    _logger.trace('Audio decoding complete');
  }

  /// Gets the duration of an audio file in seconds.
  Future<double?> getDuration(File file) async {
    final ffprobePath = await _findFfprobe();
    if (ffprobePath == null) return null;

    final result = await Process.run(
      ffprobePath,
      [
        '-v', 'error',
        '-show_entries', 'format=duration',
        '-of', 'default=noprint_wrappers=1:nokey=1',
        file.path,
      ],
    );

    if (result.exitCode == 0) {
      return double.tryParse(result.stdout.toString().trim());
    }
    return null;
  }

  /// Finds the FFmpeg executable in the system PATH.
  Future<String?> _findFfmpeg() async {
    return _findExecutable('ffmpeg');
  }

  /// Finds the FFprobe executable in the system PATH.
  Future<String?> _findFfprobe() async {
    return _findExecutable('ffprobe');
  }

  /// Finds an executable in the system PATH.
  Future<String?> _findExecutable(String name) async {
    final isWindows = Platform.isWindows;
    final execName = isWindows ? '$name.exe' : name;

    // Try using 'which' (Unix) or 'where' (Windows)
    final command = isWindows ? 'where' : 'which';

    try {
      final result = await Process.run(command, [execName]);
      if (result.exitCode == 0) {
        final path = result.stdout.toString().trim().split('\n').first;
        return path.isNotEmpty ? path : null;
      }
    } catch (_) {
      // Command failed, try common paths
    }

    // Try common installation paths
    final commonPaths = isWindows
        ? [
            'C:\\ffmpeg\\bin\\$execName',
            'C:\\Program Files\\ffmpeg\\bin\\$execName',
          ]
        : [
            '/usr/bin/$name',
            '/usr/local/bin/$name',
            '/opt/homebrew/bin/$name',
          ];

    for (final path in commonPaths) {
      if (File(path).existsSync()) {
        return path;
      }
    }

    return null;
  }
}

/// Exception thrown when FFmpeg operations fail.
class FfmpegException implements Exception {
  final String message;
  FfmpegException(this.message);

  @override
  String toString() => 'FfmpegException: $message';
}
