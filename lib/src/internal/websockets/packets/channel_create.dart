import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ChannelCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.channelCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildChannel? channel = ChannelWrapper.create(payload);

    if (channel != null) {
      guild?.channels.cache.set(channel.id, channel);
    }

    manager.emit(
      event: Events.channelCreate,
      params: [channel]
    );
  }
}
