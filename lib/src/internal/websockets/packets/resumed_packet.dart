import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/events/resumed_event.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ResumedPacket with Container implements WebsocketPacket {
  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    final EventManager eventManager = container.use<EventManager>();

    eventManager.controller.add(ResumedEvent(websocketResponse.payload));
  }
}
