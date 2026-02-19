import 'dart:convert';

import 'package:eterl/eterl.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_requested_message.dart';

final class EtfEncoderStrategy implements EncodingStrategy {
  @override
  WsEncoder get encoder => WsEncoder.etf;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  @override
  WebsocketMessage decode(WebsocketMessage message) {
    try {
      final content =
          eterl.unpack<Map<String, dynamic>>(message.originalContent);
      return message..content = ShardMessage.of(content);
    } on Exception catch (e) {
      _logger.error('Failed to decode ETF WebSocket message: $e');
      rethrow;
    }
  }

  @override
  WebsocketRequestedMessage encode(WebsocketRequestedMessage message) {
    try {
      return message..content = eterl.pack(json.decode(message.content));
    } on Exception catch (e) {
      _logger.error('Failed to encode ETF WebSocket message: $e');
      rethrow;
    }
  }
}
