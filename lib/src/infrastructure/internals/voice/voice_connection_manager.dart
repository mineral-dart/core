import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/voice/voice_connection_state.dart';
import 'package:mineral/src/api/server/voice/voice_context.dart';
import 'package:mineral/src/api/server/voice/voice_connection.dart';
import 'package:mineral/src/domains/services/wss/constants/op_code.dart';
import 'package:mineral/src/infrastructure/internals/wss/builders/discord_message_builder.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_isolate_message_transfert.dart';

/// Manages voice connections per guild.
///
/// Handles the coordination between the main gateway (for VOICE_STATE_UPDATE)
/// and the voice gateway for actual audio transmission.
final class VoiceConnectionManager {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();
  WebsocketOrchestratorContract get _wss =>
      ioc.resolve<WebsocketOrchestratorContract>();

  /// Active voice connections, keyed by server ID
  final Map<Snowflake, VoiceConnection> _connections = {};

  /// Pending join operations waiting for VOICE_SERVER_UPDATE
  final Map<Snowflake, Completer<VoiceContext>> _pendingJoins = {};

  /// Pending data from VOICE_STATE_UPDATE (session_id, channel_id)
  final Map<Snowflake, _PendingVoiceData> _pendingData = {};

  /// Returns the active connection for a server, if any
  VoiceConnection? getConnection(Snowflake serverId) => _connections[serverId];

  /// Checks if there's an active connection for a server
  bool isConnected(Snowflake serverId) =>
      _connections[serverId]?.state == VoiceConnectionState.ready;

  /// Joins a voice channel and returns a [VoiceContext] for audio playback.
  ///
  /// This method:
  /// 1. Sends VOICE_STATE_UPDATE via the main gateway
  /// 2. Waits for VOICE_STATE_UPDATE event (session_id)
  /// 3. Waits for VOICE_SERVER_UPDATE event (endpoint, token)
  /// 4. Establishes the voice gateway connection
  /// 5. Returns a [VoiceContext] when ready
  Future<VoiceContext> join({
    required Snowflake serverId,
    required Snowflake channelId,
    bool selfMute = false,
    bool selfDeaf = false,
  }) async {
    // If already connected to this guild, disconnect first
    if (_connections.containsKey(serverId)) {
      await disconnect(serverId);
    }

    final completer = Completer<VoiceContext>();
    _pendingJoins[serverId] = completer;

    // Send VOICE_STATE_UPDATE via main gateway (op code 4)
    final message = ShardMessageBuilder()
      ..setOpCode(OpCode.voiceStateUpdate)
      ..append('guild_id', serverId.value)
      ..append('channel_id', channelId.value)
      ..append('self_mute', selfMute)
      ..append('self_deaf', selfDeaf);

    _wss.send(WebsocketIsolateMessageTransfert.send(message.toJson()));

    _logger.trace('Sent VOICE_STATE_UPDATE for guild ${serverId.value}');

    return completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        _pendingJoins.remove(serverId);
        _pendingData.remove(serverId);
        throw TimeoutException(
          'Voice connection timed out for guild ${serverId.value}',
        );
      },
    );
  }

  /// Called by VOICE_STATE_UPDATE packet listener when the bot's voice state changes.
  ///
  /// This captures the session_id needed for voice gateway authentication.
  void handleVoiceStateUpdate({
    required Snowflake serverId,
    required Snowflake? channelId,
    required String sessionId,
    required Snowflake userId,
  }) {
    // Only process if it's for our bot and we have a pending join
    final bot = ioc.resolve<Bot>();
    if (userId != bot.id) {
      return;
    }

    // If channelId is null, the bot is disconnecting
    if (channelId == null) {
      _pendingJoins.remove(serverId);
      _pendingData.remove(serverId);
      return;
    }

    _logger.trace(
      'Received VOICE_STATE_UPDATE for guild ${serverId.value}, '
      'session: $sessionId',
    );

    _pendingData[serverId] = _PendingVoiceData(
      sessionId: sessionId,
      channelId: channelId,
    );

    // Try to complete the connection if we have all the data
    _tryCompleteConnection(serverId);
  }

  /// Called by VOICE_SERVER_UPDATE packet listener.
  ///
  /// This provides the endpoint and token needed for voice gateway connection.
  Future<void> handleServerUpdate({
    required Snowflake serverId,
    required String token,
    required String? endpoint,
  }) async {
    if (endpoint == null) {
      // Voice server unavailable
      _logger.warn('Voice server unavailable for guild ${serverId.value}');
      await _handleServerUnavailable(serverId);
      return;
    }

    _logger.trace(
      'Received VOICE_SERVER_UPDATE for guild ${serverId.value}, '
      'endpoint: $endpoint',
    );

    final data = _pendingData[serverId];
    if (data == null) {
      _logger.warn(
        'Received VOICE_SERVER_UPDATE without pending voice state '
        'for guild ${serverId.value}',
      );
      return;
    }

    // Store token and endpoint
    data.token = token;
    data.endpoint = endpoint.replaceFirst(':443', '');

    // Try to complete the connection
    await _tryCompleteConnection(serverId);
  }

  /// Attempts to complete a voice connection if we have all required data.
  Future<void> _tryCompleteConnection(Snowflake serverId) async {
    final data = _pendingData[serverId];
    final completer = _pendingJoins[serverId];

    if (data == null || completer == null) return;
    if (!data.isComplete) return;

    try {
      // Create and establish the voice connection
      final connection = VoiceConnection(
        serverId: serverId,
        channelId: data.channelId!,
        sessionId: data.sessionId!,
        token: data.token!,
        endpoint: data.endpoint!,
      );

      _connections[serverId] = connection;

      _logger.trace('Establishing voice connection for guild ${serverId.value}');

      await connection.connect();
      await connection.ready;

      _logger.trace('Voice connection ready for guild ${serverId.value}');

      // Create the voice context
      final context = VoiceContext.create(
        serverId: serverId,
        channelId: data.channelId!,
        connection: connection,
      );

      // Clean up pending data
      _pendingJoins.remove(serverId);
      _pendingData.remove(serverId);

      completer.complete(context);
    } catch (e, stack) {
      _logger.error('Failed to establish voice connection: $e');
      _logger.trace(stack.toString());

      _pendingJoins.remove(serverId);
      _pendingData.remove(serverId);
      _connections.remove(serverId);

      completer.completeError(e);
    }
  }

  /// Handles when the voice server becomes unavailable.
  Future<void> _handleServerUnavailable(Snowflake serverId) async {
    final completer = _pendingJoins.remove(serverId);
    _pendingData.remove(serverId);

    final connection = _connections.remove(serverId);
    await connection?.disconnect();

    completer?.completeError(
      StateError('Voice server unavailable for guild ${serverId.value}'),
    );
  }

  /// Disconnects from a voice channel.
  Future<void> disconnect(Snowflake serverId) async {
    final connection = _connections.remove(serverId);
    if (connection != null) {
      await connection.disconnect();
    }

    // Cancel any pending joins
    _pendingJoins.remove(serverId)?.completeError(
          StateError('Disconnected from voice channel'),
        );
    _pendingData.remove(serverId);

    // Send voice state update to leave the channel
    final message = ShardMessageBuilder()
      ..setOpCode(OpCode.voiceStateUpdate)
      ..append('guild_id', serverId.value)
      ..append('channel_id', null)
      ..append('self_mute', false)
      ..append('self_deaf', false);

    _wss.send(WebsocketIsolateMessageTransfert.send(message.toJson()));

    _logger.trace('Disconnected from voice channel in guild ${serverId.value}');
  }

  /// Disconnects from all voice channels.
  Future<void> disconnectAll() async {
    final serverIds = _connections.keys.toList();
    for (final serverId in serverIds) {
      await disconnect(serverId);
    }
  }
}

/// Temporary storage for pending voice connection data.
class _PendingVoiceData {
  String? sessionId;
  Snowflake? channelId;
  String? token;
  String? endpoint;

  _PendingVoiceData({
    this.sessionId,
    this.channelId,
  });

  bool get isComplete =>
      sessionId != null &&
      channelId != null &&
      token != null &&
      endpoint != null;
}
