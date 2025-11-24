import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/wss/constants/op_code.dart';
import 'package:mineral/src/infrastructure/internals/wss/builders/discord_message_builder.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';

final class ShardAuthentication implements ShardAuthenticationContract {
  final Shard shard;

  int? sequence;
  String? sessionId;
  String? resumeUrl;
  int attempts = 0;

  ShardAuthentication(this.shard);

  @override
  void identify(Map<String, dynamic> payload) {
    createHeartbeatTimer(payload['heartbeat_interval']);

    final message = ShardMessageBuilder()
      ..setOpCode(OpCode.identify)
      ..append('token', shard.wss.config.token)
      ..append('intents', shard.wss.config.intent)
      ..append('compress', shard.wss.config.isCompressed)
      ..append('properties', {'os': 'macos', 'device': 'mineral'});

    shard.client.send(message.build());
  }

  void createHeartbeatTimer(int interval) {
    Timer.periodic(Duration(milliseconds: interval), (timer) {
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

  @override
  Future<void> reconnect() async {
    attempts = 0;
    shard.client.disconnect();
    shard.init();

    await connect();
  }

  Future<void> resetConnection() async {
    ioc.resolve<LoggerContract>().trace('Connection reset');

    attempts = 0;
    shard.client.disconnect();
    await shard.init();
  }

  @override
  void resume() {
    final message = ShardMessageBuilder()
      ..setOpCode(OpCode.resume)
      ..append('token', shard.wss.config.token)
      ..append('session_id', sessionId)
      ..append('seq', sequence);

    shard.client.send(message.build());
  }

  @override
  void setupRequirements(Map<String, dynamic> payload) {
    sequence = payload['sequence'];
    sessionId = payload['session_id'];
    resumeUrl = payload['resume_gateway_url'];
  }
}
