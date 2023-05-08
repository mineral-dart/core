import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/core/extras.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ChannelCreatePacket with Container, Console implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    PartialChannel channel = ChannelWrapper.create(payload);

    if(payload['guild_id'] != null) {
      Guild? guild = client.guilds.cache.get(payload['guild_id']);
      guild?.channels.cache.set(channel.id, channel as GuildChannel);
    }

    eventService.controller.add(ChannelCreateEvent(channel));
  }
}
