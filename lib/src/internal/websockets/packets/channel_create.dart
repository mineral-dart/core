import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

import 'package:collection/collection.dart';

class ChannelCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.channelCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    Channel? channel = guild?.channels.cache.get(payload['id']);

    if (channel == null) {
      channel = _dispatch(guild, payload);

      channel?.guildId = guild?.id;
      channel?.guild = guild;
      channel?.parent = channel.parentId != null ? guild?.channels.cache.get<CategoryChannel>(channel.parentId) : null;
      channel?.webhooks.guild = guild;

      guild?.channels.cache.putIfAbsent(channel!.id, () => channel!);
    }

    manager.emit(
      event: Events.channelCreate,
      params: [channel]
    );
  }

  Channel? _dispatch (Guild? guild, dynamic payload) {
    final ChannelType? type = ChannelType.values.firstWhereOrNull((element) => element.value == payload['type']);
    if (type != null && channels.containsKey(type)) {
      Channel Function(dynamic payload) item = channels[type] as Channel Function(dynamic payload);
      return item(payload);
    }
    return null;
  }
}
