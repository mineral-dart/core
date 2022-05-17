import 'package:mineral/src/constants.dart';
import 'package:mineral/src/websockets/websocket_packet.dart';
import 'package:mineral/src/websockets/websocket_response.dart';

class GuildCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    print(websocketResponse.payload);
  }
}
