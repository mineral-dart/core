import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ChannelCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.channelCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    Channel? channel = guild?.channels.cache.get(payload['id']);

    if (channel == null) {
      channel = _dispatch(guild, payload);

      channel?.guildId = guild?.id;
      channel?.guild = guild;
      channel?.parent = channel.parentId != null ? guild?.channels.cache.get<CategoryChannel>(channel.parentId) : null;
    }

    manager.emit(EventList.channelCreate, [channel]);
  }

  Channel? _dispatch (Guild? guild, dynamic payload) {
    if (channels.containsKey(payload['type'])) {
      Channel Function(dynamic payload) item = channels[payload['type']] as Channel Function(dynamic payload);
      Channel channel = item(payload);

      guild?.channels.cache.putIfAbsent(channel.id, () => channel);
      return channel;
    }
    return null;
  }
}
