import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

import '../../../../core/api.dart';
import '../../../../core/api.dart';

class ChannelCreatePacket with Container, Console implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    final ChannelType? channelType = ChannelType.values.firstWhere((element) => element.value == payload['type']);
    Guild? guild = client.guilds.cache.get(payload['guild_id']);

    final channel = ChannelWrapper.create(payload);

    if (channelType == null || channelType == ChannelType.groupDm) {
      return;
    }

    guild?.channels.cache.set(channel.id, channel);
    
    // if (channelType is ChannelType.private) {
    //   eventService.controller.add(DMChannelCreateEvent(channel));
    // } else {
      eventService.controller.add(ChannelCreateEvent(channel));
    // }
  }
}
