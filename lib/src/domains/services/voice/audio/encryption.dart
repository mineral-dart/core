import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Handles Discord voice encryption.
///
/// Discord supports several encryption modes:
/// - `xsalsa20_poly1305`: Original mode, nonce is the RTP header padded to 24 bytes
/// - `xsalsa20_poly1305_suffix`: Nonce is appended to the packet
/// - `xsalsa20_poly1305_lite`: Nonce is an incrementing counter appended to packet
/// - `aes256_gcm_rtpsize`: AES-256-GCM with 4-byte incrementing nonce (preferred)
///
/// All modes use authenticated encryption to ensure integrity.
final class VoiceEncryption {
  final String mode;
  final Uint8List secretKey;

  int _nonceCounter = 0;
  final Random _random = Random.secure();

  // AES-256-GCM cipher instance
  late final AesGcm _aesGcm;

  // XSalsa20-Poly1305 cipher instance (using Xchacha20 as closest alternative)
  late final Xchacha20 _xchacha20;

  VoiceEncryption({
    required this.mode,
    required this.secretKey,
  }) {
    _aesGcm = AesGcm.with256bits();
    _xchacha20 = Xchacha20.poly1305Aead();
  }

  /// Encrypts audio data for transmission.
  ///
  /// [rtpHeader] is the 12-byte RTP header
  /// [audioData] is the Opus-encoded audio frame
  ///
  /// Returns the encrypted audio (with nonce appended for suffix/lite modes)
  Future<Uint8List> encrypt(Uint8List rtpHeader, Uint8List audioData) async {
    return switch (mode) {
      'xsalsa20_poly1305' => await _encryptXSalsa(rtpHeader, audioData),
      'xsalsa20_poly1305_suffix' => await _encryptXSalsaSuffix(audioData),
      'xsalsa20_poly1305_lite' => await _encryptXSalsaLite(audioData),
      'aes256_gcm_rtpsize' => await _encryptAesGcmRtpsize(rtpHeader, audioData),
      _ => throw UnsupportedError('Unsupported encryption mode: $mode'),
    };
  }

  /// XSalsa20-Poly1305 encryption (using XChaCha20-Poly1305 as similar construct).
  /// Nonce is the RTP header padded to 24 bytes with zeros.
  Future<Uint8List> _encryptXSalsa(Uint8List rtpHeader, Uint8List audioData) async {
    // Nonce: RTP header (12 bytes) + 12 bytes of zeros = 24 bytes
    final nonce = Uint8List(24);
    nonce.setRange(0, 12, rtpHeader);

    final secretBox = await _xchacha20.encrypt(
      audioData,
      secretKey: SecretKey(secretKey),
      nonce: nonce,
    );

    // Return ciphertext + MAC (tag)
    return Uint8List.fromList([...secretBox.cipherText, ...secretBox.mac.bytes]);
  }

  /// XSalsa20-Poly1305 with suffix mode.
  /// A random 24-byte nonce is generated and appended to the ciphertext.
  Future<Uint8List> _encryptXSalsaSuffix(Uint8List audioData) async {
    // Generate random nonce
    final nonce = _generateRandomNonce(24);

    final secretBox = await _xchacha20.encrypt(
      audioData,
      secretKey: SecretKey(secretKey),
      nonce: nonce,
    );

    // Return ciphertext + MAC + nonce
    return Uint8List.fromList([
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
      ...nonce,
    ]);
  }

  /// XSalsa20-Poly1305 with lite mode.
  /// Uses a 4-byte incrementing counter as nonce (padded to 24 bytes).
  Future<Uint8List> _encryptXSalsaLite(Uint8List audioData) async {
    // Nonce: 4-byte counter (big-endian) + 20 bytes of zeros
    final nonce = Uint8List(24);
    final view = ByteData.view(nonce.buffer);
    view.setUint32(0, _nonceCounter, Endian.big);
    _nonceCounter++;

    final secretBox = await _xchacha20.encrypt(
      audioData,
      secretKey: SecretKey(secretKey),
      nonce: nonce,
    );

    // Return ciphertext + MAC + 4-byte counter
    return Uint8List.fromList([
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
      ...nonce.sublist(0, 4),
    ]);
  }

  /// AES-256-GCM with RTP size mode.
  /// Uses a 4-byte incrementing counter and includes RTP header as additional data.
  Future<Uint8List> _encryptAesGcmRtpsize(Uint8List rtpHeader, Uint8List audioData) async {
    // Nonce: 4-byte counter (big-endian) padded to 12 bytes
    final nonce = Uint8List(12);
    final view = ByteData.view(nonce.buffer);
    view.setUint32(0, _nonceCounter, Endian.big);
    _nonceCounter++;

    final secretBox = await _aesGcm.encrypt(
      audioData,
      secretKey: SecretKey(secretKey),
      nonce: nonce,
      aad: rtpHeader, // RTP header as additional authenticated data
    );

    // Return ciphertext + MAC (16 bytes) + 4-byte counter
    return Uint8List.fromList([
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
      ...nonce.sublist(0, 4),
    ]);
  }

  /// Generates a random nonce of the specified length.
  Uint8List _generateRandomNonce(int length) {
    final nonce = Uint8List(length);
    for (int i = 0; i < length; i++) {
      nonce[i] = _random.nextInt(256);
    }
    return nonce;
  }
}
