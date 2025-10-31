import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_requested_message.dart';

abstract interface class EncodingStrategy {
  WsEncoder get encoder;
  WebsocketMessage decode(WebsocketMessage message);
  WebsocketRequestedMessage encode(WebsocketRequestedMessage message);
}
