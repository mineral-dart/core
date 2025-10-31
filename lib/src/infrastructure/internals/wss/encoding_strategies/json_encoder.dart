import 'dart:convert';

import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_requested_message.dart';

final class JsonEncoderStrategy implements EncodingStrategy {
  @override
  WsEncoder get encoder => WsEncoder.json;

  @override
  WebsocketMessage decode(WebsocketMessage message) {
    return message
      ..content = ShardMessage.of(
        json.decode(message.originalContent),
      );
  }

  @override
  WebsocketRequestedMessage encode(WebsocketRequestedMessage message) =>
      message;
}
