
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/websockets/packets/guild_create.dart';
import 'package:mineral/src/internal/websockets/packets/presence_update.dart';
import 'package:mineral/src/internal/websockets/packets/ready.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class WebsocketDispatcher {
  final Map<PacketType, List<WebsocketPacket>> _packets = {};

  WebsocketDispatcher() {
    register(PacketType.ready, Ready());
    register(PacketType.guildCreate, GuildCreate());
    register(PacketType.presenceUpdate, PresenceUpdate());
  }

  void register (PacketType type, WebsocketPacket packet) {
    if (_packets.containsKey(type)) {
      List<WebsocketPacket> packets = _packets[type]!;
      packets.add(packet);
    } else {
      _packets.putIfAbsent(type, () => List.filled(1, packet));
    }
  }

  Future<void> dispatch (WebsocketResponse websocketResponse) async {
    PacketType? packet = PacketType.values.firstWhere((element) => element.toString() == websocketResponse.type);

    if (_packets.containsKey(packet)) {
      List<WebsocketPacket> packets = _packets[packet]!;
      for (var packet in packets) {
        await packet.handle(websocketResponse);
      }
    }
  }
}
