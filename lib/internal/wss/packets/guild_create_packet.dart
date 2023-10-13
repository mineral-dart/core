import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class GuildCreatePacket implements PacketContract {
  @override
  Future<void> handle(WebsocketResponse response) async {
    print("guild create packet handled");

    final { "id": id } = response.payload;

    print(id);
    Client client = container.use<Client>('client');
    print("Client in guild create packet: ${client.user.username}");
  }
}