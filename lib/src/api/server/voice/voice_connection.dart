import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/voice/voice_connection_state.dart';
import 'package:mineral/src/api/server/voice/voice_udp_client.dart';
import 'package:mineral/src/domains/services/voice/voice_op_code.dart';

/// Manages a single voice connection to a Discord voice server.
///
/// Handles the voice gateway WebSocket connection, UDP audio transmission,
/// and the handshake flow required to establish a working voice connection.
final class VoiceConnection {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  final Snowflake serverId;
  final Snowflake channelId;
  final String sessionId;
  final String token;
  final String endpoint;

  io.WebSocket? _gateway;
  StreamSubscription? _gatewaySubscription;
  Timer? _heartbeatTimer;
  VoiceUdpClient? _udpClient;

  VoiceConnectionState _state = VoiceConnectionState.disconnected;
  VoiceConnectionState get state => _state;

  // From READY payload
  int? _ssrc;
  int? _port;
  String? _ip;
  List<String>? _modes;

  // From SESSION_DESCRIPTION
  List<int>? _secretKey;
  String? _encryptionMode;

  // IP Discovery results
  String? _externalIp;
  int? _externalPort;

  final Completer<void> _readyCompleter = Completer<void>();

  /// Completes when the voice connection is fully established and ready.
  Future<void> get ready => _readyCompleter.future;

  /// The SSRC (Synchronization Source) for this connection
  int? get ssrc => _ssrc;

  /// The secret key for audio encryption
  List<int>? get secretKey => _secretKey;

  /// The encryption mode in use
  String? get encryptionMode => _encryptionMode;

  VoiceConnection({
    required this.serverId,
    required this.channelId,
    required this.sessionId,
    required this.token,
    required this.endpoint,
  });

  /// Establishes the voice connection.
  Future<void> connect() async {
    _state = VoiceConnectionState.connecting;

    final url = 'wss://$endpoint?v=4';
    _logger.trace('Connecting to voice gateway: $url');

    try {
      _gateway = await io.WebSocket.connect(url);

      _gatewaySubscription = _gateway!.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleClose,
      );
    } catch (e) {
      _state = VoiceConnectionState.disconnected;
      rethrow;
    }
  }

  void _handleMessage(dynamic rawMessage) {
    try {
      final data = jsonDecode(rawMessage as String) as Map<String, dynamic>;
      final opValue = data['op'] as int;
      final opCode = VoiceOpCode.fromValue(opValue);
      final payload = data['d'] as Map<String, dynamic>?;

      _logger.trace('Voice gateway received op $opValue: ${opCode?.name ?? 'unknown'}');

      switch (opCode) {
        case VoiceOpCode.hello:
          _handleHello(payload!);
        case VoiceOpCode.ready:
          _handleReady(payload!);
        case VoiceOpCode.sessionDescription:
          _handleSessionDescription(payload!);
        case VoiceOpCode.heartbeatAck:
          _logger.trace('Voice heartbeat ACK received');
        case VoiceOpCode.resumed:
          _logger.trace('Voice connection resumed');
        case VoiceOpCode.clientDisconnect:
          _logger.trace('Client disconnected from voice');
        default:
          _logger.trace('Unhandled voice op: $opValue');
      }
    } catch (e, stack) {
      _logger.error('Error handling voice gateway message: $e');
      _logger.trace(stack.toString());
    }
  }

  void _handleHello(Map<String, dynamic> payload) {
    final intervalMs = (payload['heartbeat_interval'] as num).toDouble();

    // Send identify FIRST, then start heartbeating
    _sendIdentify();
    _startHeartbeat(intervalMs);
  }

  void _sendIdentify() {
    _state = VoiceConnectionState.identifying;

    final bot = ioc.resolve<Bot>();
    final payload = {
      'server_id': serverId.value,
      'user_id': bot.id.value,
      'session_id': sessionId,
      'token': token,
    };

    final message = {
      'op': VoiceOpCode.identify.value,
      'd': payload,
    };

    _logger.trace('Sending voice IDENTIFY: $payload');
    _send(message);
  }

  void _handleReady(Map<String, dynamic> payload) {
    _ssrc = payload['ssrc'] as int;
    _port = payload['port'] as int;
    _ip = payload['ip'] as String;
    _modes = List<String>.from(payload['modes'] as List);

    _logger.trace(
      'Voice READY: ssrc=$_ssrc, port=$_port, ip=$_ip, '
      'modes=${_modes?.join(', ')}',
    );

    _state = VoiceConnectionState.udpSetup;
    _establishUdp();
  }

  Future<void> _establishUdp() async {
    try {
      _udpClient = VoiceUdpClient(
        ip: _ip!,
        port: _port!,
        ssrc: _ssrc!,
      );

      await _udpClient!.connect();

      // Perform IP discovery
      final (externalIp, externalPort) = await _udpClient!.discoverIp();
      _externalIp = externalIp;
      _externalPort = externalPort;

      _logger.trace('IP Discovery result: $_externalIp:$_externalPort');

      _sendSelectProtocol();
    } catch (e, stack) {
      _logger.error('UDP setup failed: $e');
      _logger.trace(stack.toString());

      if (!_readyCompleter.isCompleted) {
        _readyCompleter.completeError(e);
      }
    }
  }

  void _sendSelectProtocol() {
    _state = VoiceConnectionState.selectingProtocol;

    // Prefer aes256_gcm_rtpsize, fallback to xsalsa20_poly1305
    final preferredModes = [
      'aes256_gcm_rtpsize',
      'xsalsa20_poly1305_lite',
      'xsalsa20_poly1305_suffix',
      'xsalsa20_poly1305',
    ];

    String? selectedMode;
    for (final mode in preferredModes) {
      if (_modes!.contains(mode)) {
        selectedMode = mode;
        break;
      }
    }

    if (selectedMode == null) {
      final error = StateError('No supported encryption mode found');
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.completeError(error);
      }
      return;
    }

    _logger.trace('Selected encryption mode: $selectedMode');

    final message = {
      'op': VoiceOpCode.selectProtocol.value,
      'd': {
        'protocol': 'udp',
        'data': {
          'address': _externalIp,
          'port': _externalPort,
          'mode': "aead_aes256_gcm_rtpsize",
        }
      }
    };

    _send(message);
    _logger.trace('Sent SELECT_PROTOCOL');
  }

  void _handleSessionDescription(Map<String, dynamic> payload) {
    _secretKey = List<int>.from(payload['secret_key'] as List);
    _encryptionMode = payload['mode'] as String;

    _logger.trace('Session description received, mode: $_encryptionMode');

    // Configure the UDP client with the encryption key
    _udpClient!.setEncryption(_encryptionMode!, _secretKey!);

    _state = VoiceConnectionState.ready;

    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
  }

  void _startHeartbeat(double intervalMs) {
    _heartbeatTimer?.cancel();

    // Use the full interval for the timer
    final interval = intervalMs.toInt();

    _heartbeatTimer = Timer.periodic(
      Duration(milliseconds: interval),
      (_) => _sendHeartbeat(),
    );

    // Send first heartbeat after a jittered delay (not immediately)
    final jitterDelay = (intervalMs * 0.5).toInt(); // 50% jitter
    Future.delayed(Duration(milliseconds: jitterDelay), _sendHeartbeat);
  }

  void _sendHeartbeat() {
    final message = {
      'op': VoiceOpCode.heartbeat.value,
      'd': DateTime.now().millisecondsSinceEpoch,
    };
    _send(message);
  }

  void _handleError(Object error) {
    _logger.error('Voice gateway error: $error');
  }

  void _handleClose() {
    final closeCode = _gateway?.closeCode;
    final closeReason = _gateway?.closeReason;
    _logger.trace('Voice gateway closed: code=$closeCode, reason=$closeReason');
    _state = VoiceConnectionState.disconnected;
    _heartbeatTimer?.cancel();

    // Complete with error if not ready yet
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.completeError(
        StateError('Voice gateway closed unexpectedly: code=$closeCode, reason=$closeReason'),
      );
    }
  }

  void _send(Map<String, dynamic> message) {
    if (_gateway?.readyState == io.WebSocket.open) {
      _gateway!.add(jsonEncode(message));
    }
  }

  /// Sets the speaking state.
  ///
  /// [speaking] should be true when starting to transmit audio,
  /// false when stopping.
  void setSpeaking(bool speaking) {
    final message = {
      'op': VoiceOpCode.speaking.value,
      'd': {
        'speaking': speaking ? 5 : 0, // 5 = microphone + priority
        'delay': 0,
        'ssrc': _ssrc,
      }
    };
    _send(message);
    _logger.trace('Set speaking: $speaking');
  }

  /// Sends an encrypted audio packet.
  Future<void> sendAudio(List<int> opusData) async {
    await _udpClient?.sendAudioPacket(opusData);
  }

  /// Disconnects from the voice channel.
  Future<void> disconnect() async {
    _heartbeatTimer?.cancel();
    _udpClient?.close();
    _gatewaySubscription?.cancel();

    if (_gateway?.readyState == io.WebSocket.open) {
      await _gateway?.close(1000, 'Normal closure');
    }

    _state = VoiceConnectionState.disconnected;
    _logger.trace('Voice connection disconnected');
  }
}
