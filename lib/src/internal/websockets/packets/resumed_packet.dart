import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/events/resumed_event.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ResumedPacket with Container implements WebsocketPacket {
  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    final EventService eventService = container.use<EventService>();

    eventService.controller.add(ResumedEvent(websocketResponse.payload));
  }
}
