import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ChannelUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.channelUpdate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    Channel? before = guild?.channels.cache.get(payload['id']);

    Channel? after = _dispatch(guild, payload);
    if (after != null) {
      after.guildId = guild?.id;
      after.guild = guild;
      after.parent = after.parentId != null ? guild?.channels.cache.get<CategoryChannel>(after.parentId) : null;

      manager.emit(
        event: Events.channelUpdate,
        params: [before, after]
      );

      guild?.channels.cache.set(after.id, after);
    }
  }

  Channel? _dispatch (Guild? guild, dynamic payload) {
    if (channels.containsKey(payload['type'])) {
      Channel Function(dynamic payload) item = channels[payload['type']] as Channel Function(dynamic payload);
      return item(payload);
    }
    return null;
  }
}
