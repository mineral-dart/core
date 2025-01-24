import 'dart:convert';

import 'package:eterl/eterl.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_requested_message.dart';

final class EtfEncoderStrategy implements EncodingStrategy {
  @override
  WsEncoder get encoder => WsEncoder.etf;

  @override
  WebsocketMessage decode(WebsocketMessage message) {
    final content = eterl.unpack<Map<String, dynamic>>(message.originalContent);
    return message..content = ShardMessage.of(content);
  }

  @override
  WebsocketRequestedMessage encode(WebsocketRequestedMessage message) {
    return message..content = eterl.pack(json.decode(message.content));
  }
}
