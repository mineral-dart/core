import 'package:mineral/core/events.dart';
import 'package:mineral/src/api/invites/invite.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class InviteCreatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();

    eventService.controller.add(InviteCreateEvent(Invite.from(websocketResponse.payload)));
  }
}
