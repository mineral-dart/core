import 'package:mineral/src/websockets/packets/guild_create.dart';
import 'package:mineral/src/websockets/packets/ready.dart';
import 'package:mineral/src/websockets/websocket_packet.dart';
import 'package:mineral/src/websockets/websocket_response.dart';

class WebsocketDispatcher {
  final Map<String, List<WebsocketPacket>> _packets = {};

  WebsocketDispatcher() {
    register('READY', Ready());
    register('GUILD_CREATE', GuildCreate());
  }

  void register (String type, WebsocketPacket packet) {
    if (_packets.containsKey(type)) {
      List<WebsocketPacket> packets = _packets[type]!;
      packets.add(packet);
    } else {
      _packets.putIfAbsent(type, () => List.filled(1, packet));
    }
  }

  Future<void> dispatch (WebsocketResponse websocketResponse) async {
    if (_packets.containsKey(websocketResponse.type)) {
      List<WebsocketPacket> packets = _packets[websocketResponse.type]!;
      for (var packet in packets) {
        await packet.handle(websocketResponse);
      }
    }
  }
}
