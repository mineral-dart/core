import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ChannelDelete implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.channelDelete;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    Channel? channel = guild?.channels.cache.get(payload['id']);

    manager.emit(EventList.channelDelete, [channel]);
    guild?.channels.cache.remove(payload['id']);
  }
}
