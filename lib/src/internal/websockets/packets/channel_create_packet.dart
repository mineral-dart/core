import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral/src/api/channels/dm_channel.dart';
import 'package:mineral/src/api/channels/news_channel.dart';

import 'package:mineral/src/api/channels/stage_channel.dart';
import 'package:mineral/src/internal/websockets/events/dm_channel_create_event.dart';

class ChannelCreatePacket with Container, Console implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    final ChannelType? channelType = ChannelType.values.firstWhere((element) => element.value == payload['type']);
    Guild? guild = client.guilds.cache.get(payload['guild_id']);

    final channel = ChannelWrapper.create(payload);

    if (channelType == null) {
      return null;
    }

    guild?.channels.cache.set(channel.id, channel);
    
    if(channelType.equals(ChannelType.private)) {
      eventService.controller.add(DMChannelCreateEvent(channel));
    } else {
      eventService.controller.add(ChannelCreateEvent(channel));
    }
  }
}
