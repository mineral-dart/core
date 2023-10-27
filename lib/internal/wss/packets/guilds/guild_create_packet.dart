import 'dart:async';

import 'package:mineral/internal/factories/events/contracts/guilds/guild_create_event_contract.dart';
import 'package:mineral/internal/factories/events/event_factory.dart';
import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/server/caches/guild_cache.dart';
import 'package:mineral/api/server/guild.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class GuildCreatePacket implements PacketContract {
  @override
  final EventFactory eventFactory;

  GuildCreatePacket(this.eventFactory);

  @override
  Future<void> handle(WebsocketResponse response) async {
    Client client = container.use<Client>('client');
    final GuildCache guilds = client.guilds as GuildCache;
    Guild guild = guilds.from(response.payload);

    guilds.cache.putIfAbsent(guild.id, () => guild);

    eventFactory.dispatch<GuildCreateEventContract>(
      (event) => event.handle(guild)
    );
  }
}