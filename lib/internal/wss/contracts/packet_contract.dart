import 'package:mineral/internal/factories/events/event_factory.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

abstract interface class PacketContract  {
  abstract final EventFactory eventFactory;
  Future<void> handle (WebsocketResponse response);
}