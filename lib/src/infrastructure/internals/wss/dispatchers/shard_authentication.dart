import 'dart:async';
import 'dart:math';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/wss/constants/op_code.dart';
import 'package:mineral/src/infrastructure/internals/wss/builders/discord_message_builder.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';
import 'package:mineral/src/infrastructure/io/exceptions/fatal_gateway_exception.dart';

final class ShardAuthentication implements ShardAuthenticationContract {
  final Shard shard;
  final Random _random = Random();

  int? sequence;
  String? sessionId;
  String? resumeUrl;
  int attempts = 0;
  int _reconnectAttempts = 0;
  bool _pendingResume = false;
  Timer? _heartbeatTimer;

  ShardAuthentication(this.shard);

  @override
  void identify(Map<String, dynamic> payload) {
    createHeartbeatTimer(payload['heartbeat_interval']);

    if (_pendingResume) {
      _pendingResume = false;

      final message = ShardMessageBuilder()
        ..setOpCode(OpCode.resume)
        ..append('token', shard.wss.config.token)
        ..append('session_id', sessionId)
        ..append('seq', sequence);

      shard.client.send(message.build());
      return;
    }

    final message = ShardMessageBuilder()
      ..setOpCode(OpCode.identify)
      ..append('token', shard.wss.config.token)
      ..append('intents', shard.wss.config.intent)
      ..append('compress', shard.wss.config.compress)
      ..append('properties', {'os': 'macos', 'device': 'mineral'});

    shard.client.send(message.build());
  }

  void createHeartbeatTimer(int interval) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      heartbeat();
    });
  }

  @override
  Future<void> heartbeat() async {
    if (attempts >= 3) {
      ioc.resolve<LoggerContract>().error('Heartbeat failed 3 times');
      return resetConnection();
    }

    final message = ShardMessageBuilder()..setOpCode(OpCode.heartbeat);
    shard.client.send(message.build());

    attempts++;
  }

  @override
  void ack() {
    ioc.resolve<LoggerContract>().trace('Received heartbeat ack');
    attempts = 0;
  }

  @override
  Future<void> connect() => shard.client.connect();

  void cancelHeartbeat() {
    _heartbeatTimer?.cancel();
  }

  Duration _backoffDelay() {
    final maxDelay = shard.wss.config.maxReconnectDelay;
    final baseSeconds =
        min(pow(2, _reconnectAttempts).toInt(), maxDelay.inSeconds);
    final jitter = Duration(milliseconds: _random.nextInt(1000));
    return Duration(seconds: baseSeconds) + jitter;
  }

  @override
  Future<void> reconnect() async {
    final logger = ioc.resolve<LoggerContract>();
    final maxAttempts = shard.wss.config.maxReconnectAttempts;

    cancelHeartbeat();
    attempts = 0;
    shard.client.disconnect();

    _reconnectAttempts++;

    if (_reconnectAttempts > maxAttempts) {
      logger.error(
          'Max reconnect attempts ($maxAttempts) reached for ${shard.shardName}');
      throw FatalGatewayException(
        'Max reconnect attempts ($maxAttempts) reached',
        -1,
      );
    }

    final delay = _backoffDelay();
    logger.warn(
        'Reconnecting ${shard.shardName} in ${delay.inSeconds}s (attempt $_reconnectAttempts/$maxAttempts)');
    await Future<void>.delayed(delay);

    await shard.init();
  }

  Future<void> resetConnection() async {
    ioc.resolve<LoggerContract>().trace('Connection reset');

    cancelHeartbeat();
    attempts = 0;
    shard.client.disconnect();

    _reconnectAttempts++;

    final maxAttempts = shard.wss.config.maxReconnectAttempts;
    if (_reconnectAttempts > maxAttempts) {
      ioc.resolve<LoggerContract>().error(
          'Max reconnect attempts ($maxAttempts) reached for ${shard.shardName}');
      throw FatalGatewayException(
        'Max reconnect attempts ($maxAttempts) reached',
        -1,
      );
    }

    final delay = _backoffDelay();
    ioc.resolve<LoggerContract>().warn(
        'Resetting connection for ${shard.shardName} in ${delay.inSeconds}s (attempt $_reconnectAttempts/$maxAttempts)');
    await Future<void>.delayed(delay);

    await shard.init();
  }

  @override
  Future<void> resume() async {
    final logger = ioc.resolve<LoggerContract>();
    final maxAttempts = shard.wss.config.maxReconnectAttempts;

    cancelHeartbeat();
    _pendingResume = true;
    attempts = 0;
    shard.client.disconnect();

    _reconnectAttempts++;

    if (_reconnectAttempts > maxAttempts) {
      logger.error(
          'Max reconnect attempts ($maxAttempts) reached for ${shard.shardName}');
      throw FatalGatewayException(
        'Max reconnect attempts ($maxAttempts) reached',
        -1,
      );
    }

    final delay = _backoffDelay();
    logger.warn(
        'Resuming ${shard.shardName} in ${delay.inSeconds}s (attempt $_reconnectAttempts/$maxAttempts)');
    await Future<void>.delayed(delay);

    await shard.init(url: resumeUrl);
  }

  @override
  void setupRequirements(Map<String, dynamic> payload) {
    _reconnectAttempts = 0;
    sequence = payload['sequence'];
    sessionId = payload['session_id'];
    resumeUrl = payload['resume_gateway_url'];
  }
}
