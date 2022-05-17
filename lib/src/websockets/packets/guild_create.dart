import 'package:mineral/src/api/user.dart';
import 'package:mineral/src/constants.dart';
import 'package:mineral/src/websockets/websocket_packet.dart';
import 'package:mineral/src/websockets/websocket_response.dart';

class GuildCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    for(dynamic member in websocketResponse.payload['members']) {
      print(User.from(member['user']));
      print(User.from(member['user']).username);
    }
  }
}
