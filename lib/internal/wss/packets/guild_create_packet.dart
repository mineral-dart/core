import 'package:mineral/internal/factories/event_factory.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class GuildCreatePacket implements PacketContract {
  @override
  final EventFactory eventFactory;

  GuildCreatePacket(this.eventFactory);

  @override
  Future<void> handle(WebsocketResponse response) async {
    final { "id": id } = response.payload;
  }
}