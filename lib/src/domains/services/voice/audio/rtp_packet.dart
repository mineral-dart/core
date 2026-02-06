import 'dart:typed_data';

/// Builds RTP (Real-time Transport Protocol) packets for Discord voice.
///
/// RTP Header format (12 bytes):
/// ```
/// 0                   1                   2                   3
/// 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// |V=2|P|X|  CC   |M|     PT      |       sequence number         |
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// |                           timestamp                           |
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// |           synchronization source (SSRC) identifier            |
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// ```
///
/// For Discord:
/// - Version (V): 2
/// - Padding (P): 0
/// - Extension (X): 0
/// - CSRC count (CC): 0
/// - Marker (M): 0
/// - Payload type (PT): 0x78 (120, dynamic for Opus)
abstract final class RtpPacket {
  /// RTP header size in bytes
  static const int headerSize = 12;

  /// Builds an RTP header for voice transmission.
  ///
  /// - [sequence]: 16-bit sequence number, wraps at 65535
  /// - [timestamp]: 32-bit timestamp, increments by frame size (960 for 20ms at 48kHz)
  /// - [ssrc]: Synchronization source identifier from Discord
  static Uint8List buildHeader({
    required int sequence,
    required int timestamp,
    required int ssrc,
  }) {
    final header = Uint8List(headerSize);
    final view = ByteData.view(header.buffer);

    // First byte: Version (2), Padding (0), Extension (0), CSRC count (0)
    // Binary: 10000000 = 0x80
    header[0] = 0x80;

    // Second byte: Marker (0), Payload type (0x78 = 120 for Opus)
    header[1] = 0x78;

    // Sequence number (16 bits, big endian)
    view.setUint16(2, sequence & 0xFFFF, Endian.big);

    // Timestamp (32 bits, big endian)
    view.setUint32(4, timestamp, Endian.big);

    // SSRC (32 bits, big endian)
    view.setUint32(8, ssrc, Endian.big);

    return header;
  }
}
