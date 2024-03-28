import 'dart:async';
import 'dart:convert';

import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/wss/builders/discord_message_builder.dart';
import 'package:mineral/domains/wss/constants/op_code.dart';
import 'package:mineral/domains/wss/shard.dart';

abstract interface class ShardAuthentication {
  void setupRequirements(Map<String, dynamic> payload);

  void identify(Map<String, dynamic> payload);

  Future<void> connect();

  void reconnect();

  void ack();

  void resume();
}

final class ShardAuthenticationImpl implements ShardAuthentication {
  final Shard shard;

  int? sequence;
  String? sessionId;
  String? resumeUrl;

  ShardAuthenticationImpl(this.shard);

  @override
  void identify(Map<String, dynamic> payload) {
    createHeartbeatTimer(payload['heartbeat_interval']);

    final message = ShardMessageBuilder()
        .setOpCode(OpCode.identify)
        .append('token', shard.kernel.config.token)
        .append('intents', shard.kernel.config.intent)
        .append('compress', shard.kernel.config.compress)
        .append('properties', {'\$os': 'macos', '\$device': 'mineral'});

    shard.client.send(message.build());
  }

  void createHeartbeatTimer(int interval) {
    Timer.periodic(Duration(milliseconds: interval), (timer) {
      heartbeat();
    });
  }

  void heartbeat() {
    shard.client.send(jsonEncode({
      'op': 1,
      'd': null,
    }));
  }

  @override
  void ack() {
    Logger.singleton().trace('Received heartbeat ack');
  }

  @override
  Future<void> connect() async {
    await shard.client.connect();
  }

  @override
  void reconnect() {
    shard.client.disconnect();
    shard.init();
    connect();
  }

  @override
  void resume() {
    final message = ShardMessageBuilder()
        .setOpCode(OpCode.resume)
        .append('token', shard.kernel.config.token)
        .append('session_id', sessionId)
        .append('seq', sequence);

    shard.client.send(message.build());
  }

  @override
  void setupRequirements(Map<String, dynamic> payload) {
    sequence = payload['sequence'];
    sessionId = payload['session_id'];
    resumeUrl = payload['resume_gateway_url'];
  }
}
