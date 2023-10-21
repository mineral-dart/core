import 'dart:async';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/factories/contracts/guilds/guild_delete_event_contract.dart';
import 'package:mineral/internal/factories/event_factory.dart';
import 'package:mineral/api/common/client/client.dart';
import 'package:mineral/api/server/caches/guild_cache.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/wss/contracts/packet_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class GuildDeletePacket implements PacketContract {
  @override
  final EventFactory eventFactory;

  GuildDeletePacket(this.eventFactory);

  @override
  Future<void> handle(WebsocketResponse response) async {
    final Client client = container.use<Client>('client');
    final GuildCache guilds = client.guilds as GuildCache;
    final GuildContract guild = guilds.cache.getOrFail(Snowflake(response.payload['id']));

    guilds.cache.remove(guild.id);

    eventFactory.dispatch<GuildDeleteEventContract>(
      (event) => event.handle(guild)
    );
  }
}