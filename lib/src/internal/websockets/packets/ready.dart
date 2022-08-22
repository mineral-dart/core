import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class Ready implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.ready;

  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(ioc.services.event);
    CommandManager commandManager = ioc.singleton(ioc.services.command);
    ShardManager shardManager = ioc.singleton(ioc.services.shards);

    if (ioc.singleton(ioc.services.client) == null) {
      MineralClient client = MineralClient.from(payload: websocketResponse.payload);
      client.uptime = DateTime.now();

      ioc.bind(namespace: ioc.services.client, service: client);

      await client.registerGlobalCommands(commands: commandManager.getGlobals());

      infuseClientIntoEvents(
        manager: eventManager,
        client: client,
      );

      infuseClientIntoCommands(
        manager: commandManager,
        client: client,
      );
    }

    final Shard shard = websocketResponse.payload['shard'] != null
      ? shardManager.shards[websocketResponse.payload['shard'][0]]!
      : shardManager.shards[0]!;

    shard.sessionId = websocketResponse.payload['session_id'];
    shard.initialize();

    eventManager.emit(
      event: Events.ready,
      params: [ioc.singleton(ioc.services.client)]
    );
  }

  void infuseClientIntoEvents ({required EventManager manager, required MineralClient client}) {
    Map<Events, List<Map<String, dynamic>>> events = manager.getRegisteredEvents();
    events.forEach((_, events) {
      for (Map<String, dynamic> event in events) {
        event['mineralEvent']
          ..client = client
          ..stores = ioc.singleton(ioc.services.store)
          ..environment = ioc.singleton(ioc.services.environment);
      }
    });
  }

  void infuseClientIntoCommands ({required CommandManager manager, required MineralClient client}) {
    Map<String, dynamic> commands = manager.getHandlers();
    commands.forEach((_, handler) {
      handler['commandClass']
        ..client = client
        ..stores = ioc.singleton(ioc.services.store)
        ..environment = ioc.singleton(ioc.services.environment);
    });
  }
}
