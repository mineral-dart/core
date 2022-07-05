import 'dart:convert';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildScheduledEventDelete implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildScheduledEventCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildScheduledEvent? event = guild?.scheduledEvents.cache.get(payload['id']);

    if(event != null) {
      guild?.scheduledEvents.cache.remove(event.id);
      manager.emit(Events.guildScheduledEventDelete, [event]);
    }

    /*
    if (guild != null) {
      GuildScheduledEvent? before = guild.scheduledEvents.cache.get(payload['id']);
      GuildScheduledEvent after = GuildScheduledEvent.from(channelManager: guild.channels, memberManager: guild.members, payload: payload);
      guild.scheduledEvents.cache.set(after.id, after);

      manager.emit(Events.guildScheduledEventUpdate, [before, after]);
    }*/
  }
}
