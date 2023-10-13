import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class GuildCreatePacket implements PacketContract {
  @override
  Future<void> handle(WebsocketResponse response) async {
    final { "id": id } = response.payload;
  }
}