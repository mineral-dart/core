import 'package:collection/collection.dart';
import 'package:mineral/api/common/collection.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/packet_type.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/internal/wss/packets/ready_packet.dart';

import '../packets/guild_create_packet.dart';

final class WebsocketEventDispatcher {
  final Collection<PacketType, PacketContract> packets = Collection()
    ..putIfAbsent(PacketType.ready, () => ReadyPacket())
    ..putIfAbsent(PacketType.guildCreate, () => GuildCreatePacket());

  Future<void> dispatch (WebsocketResponse response, { bool pushToQueue = false }) async {
    final type = PacketType.values.firstWhereOrNull((element) => element.value == response.type);
    if (type == null) {
      return;
    }

    final packet = packets.get(type);
    packet?.handle(response);
  }
}