<<<<<<< HEAD
import 'package:mineral/internal/factories/event_factory.dart';
=======
import 'dart:async';

import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/server/caches/guild_cache.dart';
import 'package:mineral/api/server/guild.dart';
import 'package:mineral/internal/fold/container.dart';
>>>>>>> feat/guild
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class GuildCreatePacket implements PacketContract {
  @override
  final EventFactory eventFactory;

  GuildCreatePacket(this.eventFactory);

  @override
  Future<void> handle(WebsocketResponse response) async {
<<<<<<< HEAD
    final { "id": id } = response.payload;
=======
    Client client = container.use<Client>('client');
    final GuildCache guilds = client.guilds as GuildCache;
    Guild guild = guilds.from(response.payload);
    // todo emit event
>>>>>>> feat/guild
  }
}