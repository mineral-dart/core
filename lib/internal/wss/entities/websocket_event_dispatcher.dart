import 'package:collection/collection.dart';
import 'package:mineral/api/common/collection.dart';
import 'package:mineral/internal/factories/events/event_factory.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/packet_type.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/internal/wss/packets/guilds/guild_create_packet.dart';
import 'package:mineral/internal/wss/packets/guilds/guild_delete_packet.dart';
import 'package:mineral/internal/wss/packets/guilds/guild_update_packet.dart';
import 'package:mineral/internal/wss/packets/client/ready_packet.dart';


final class WebsocketEventDispatcher {
  final EventFactory eventFactory;
  final Collection<PacketType, PacketContract> _packets = Collection();

  WebsocketEventDispatcher(this.eventFactory) {
    _packets
      ..putIfAbsent(PacketType.ready, () => ReadyPacket(eventFactory))
      ..putIfAbsent(PacketType.guildCreate, () => GuildCreatePacket(eventFactory))
      ..putIfAbsent(PacketType.guildUpdate, () => GuildUpdatePacket(eventFactory))
      ..putIfAbsent(PacketType.guildDelete, () => GuildDeletePacket(eventFactory));
  }

  Future<void> dispatch (WebsocketResponse response, { bool pushToQueue = false }) async {
    final type = PacketType.values.firstWhereOrNull((element) => element.value == response.type);
    if (type == null) {
      return;
    }

    final packet = _packets.get(type);
    packet?.handle(response);
  }
}