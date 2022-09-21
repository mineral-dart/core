import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_ioc/ioc.dart';

class ChannelDelete implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.channelDelete;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildChannel? channel = guild?.channels.cache.get(payload['id']);

    manager.emit(
      event: Events.channelDelete,
      params: [channel]
    );

    guild?.channels.cache.remove(payload['id']);
  }
}
