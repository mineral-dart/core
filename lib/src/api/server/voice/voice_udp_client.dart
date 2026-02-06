import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/voice/audio/encryption.dart';
import 'package:mineral/src/domains/services/voice/audio/rtp_packet.dart';

/// UDP client for Discord voice audio transmission.
///
/// Handles:
/// - UDP socket connection
/// - IP Discovery protocol
/// - RTP packet construction
/// - Audio encryption and transmission
final class VoiceUdpClient {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  final String ip;
  final int port;
  final int ssrc;

  RawDatagramSocket? _socket;
  VoiceEncryption? _encryption;

  int _sequence = 0;
  int _timestamp = 0;

  VoiceUdpClient({
    required this.ip,
    required this.port,
    required this.ssrc,
  });

  /// Establishes the UDP connection.
  Future<void> connect() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _logger.trace('UDP socket bound to port ${_socket!.port}');
  }

  /// Performs IP Discovery to determine our external IP and port.
  ///
  /// Discord uses this to know where to send audio packets back.
  /// See: https://discord.com/developers/docs/topics/voice-connections#ip-discovery
  Future<(String, int)> discoverIp() async {
    if (_socket == null) {
      throw StateError('Socket not connected');
    }

    // Build 74-byte IP discovery request packet
    // Format:
    // - Type (2 bytes): 0x0001 (request)
    // - Length (2 bytes): 70
    // - SSRC (4 bytes)
    // - Address (64 bytes, null-padded)
    // - Port (2 bytes)
    final packet = Uint8List(74);
    final view = ByteData.view(packet.buffer);

    // Type: 0x0001 (request)
    view.setUint16(0, 0x0001, Endian.big);
    // Length: 70
    view.setUint16(2, 70, Endian.big);
    // SSRC
    view.setUint32(4, ssrc, Endian.big);

    _socket!.send(packet, InternetAddress(ip), port);
    _logger.trace('Sent IP discovery request');

    // Wait for response
    final completer = Completer<(String, int)>();

    late StreamSubscription subscription;
    subscription = _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram != null && datagram.data.length >= 74) {
          final responseView = ByteData.view(datagram.data.buffer);

          // Verify response type (0x0002)
          final type = responseView.getUint16(0, Endian.big);
          if (type != 0x0002) {
            _logger.trace('Unexpected IP discovery response type: $type');
            return;
          }

          // Extract IP (null-terminated string starting at offset 8)
          final ipBytes = datagram.data.sublist(8, 72);
          final nullIndex = ipBytes.indexOf(0);
          final externalIp = String.fromCharCodes(
            ipBytes.sublist(0, nullIndex > 0 ? nullIndex : ipBytes.length),
          );

          // Extract port (last 2 bytes)
          final externalPort = responseView.getUint16(72, Endian.big);

          subscription.cancel();
          completer.complete((externalIp, externalPort));
        }
      }
    });

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        subscription.cancel();
        throw TimeoutException('IP discovery timed out');
      },
    );
  }

  /// Configures encryption for audio transmission.
  void setEncryption(String mode, List<int> secretKey) {
    _encryption = VoiceEncryption(
      mode: mode,
      secretKey: Uint8List.fromList(secretKey),
    );
    _logger.trace('Encryption configured: $mode');
  }

  /// Sends an encrypted audio packet.
  Future<void> sendAudioPacket(List<int> opusData) async {
    if (_socket == null || _encryption == null) {
      return;
    }

    // Build RTP header
    final rtpHeader = RtpPacket.buildHeader(
      sequence: _sequence,
      timestamp: _timestamp,
      ssrc: ssrc,
    );

    // Increment sequence and timestamp
    _sequence = (_sequence + 1) & 0xFFFF; // Wrap at 16 bits
    _timestamp += 960; // 20ms at 48kHz = 960 samples

    // Encrypt the audio data
    final encrypted = await _encryption!.encrypt(rtpHeader, Uint8List.fromList(opusData));

    // Combine header and encrypted audio
    final packet = Uint8List(rtpHeader.length + encrypted.length);
    packet.setRange(0, rtpHeader.length, rtpHeader);
    packet.setRange(rtpHeader.length, packet.length, encrypted);

    // Send the packet
    _socket!.send(packet, InternetAddress(ip), port);
  }

  /// Sends silence frames.
  ///
  /// Discord recommends sending 5 frames of silence (0xF8, 0xFF, 0xFE)
  /// before stopping transmission to avoid interpolation artifacts.
  void sendSilence() {
    const silenceFrame = [0xF8, 0xFF, 0xFE];
    for (int i = 0; i < 5; i++) {
      sendAudioPacket(silenceFrame);
    }
  }

  /// Resets the sequence and timestamp counters.
  void resetCounters() {
    _sequence = 0;
    _timestamp = 0;
  }

  /// Closes the UDP connection.
  void close() {
    _socket?.close();
    _socket = null;
    _logger.trace('UDP socket closed');
  }
}
