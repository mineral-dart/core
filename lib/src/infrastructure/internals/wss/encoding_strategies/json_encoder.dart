import 'dart:convert';

import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_requested_message.dart';

final class JsonEncoderStrategy implements EncodingStrategy {
  @override
  WsEncoder get encoder => WsEncoder.json;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  @override
  WebsocketMessage decode(WebsocketMessage message) {
    try {
      return message
        ..content = ShardMessage.of(json.decode(message.originalContent));
    } on Exception catch (e) {
      _logger.error('Failed to decode JSON WebSocket message: $e');
      rethrow;
    }
  }

  @override
  WebsocketRequestedMessage encode(WebsocketRequestedMessage message) =>
      message;
}
