import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_ioc/ioc.dart';

class Ready implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.ready;

  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    CommandManager commandManager = ioc.singleton(Service.command);
    ShardManager shardManager = ioc.singleton(Service.shards);

    if (ioc.singleton(Service.client) == null) {
      MineralClient client = MineralClient.from(payload: websocketResponse.payload);
      client.uptime = DateTime.now();

      ioc.bind(namespace: Service.client, service: client);

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
    shard.resumeURL = websocketResponse.payload['resume_gateway_url'];
    shard.initialize();

    eventManager.emit(
      event: Events.ready,
      params: [ioc.singleton(Service.client)]
    );
  }

  void infuseClientIntoEvents ({required EventManager manager, required MineralClient client}) {
    Map<Events, List<Map<String, dynamic>>> events = manager.getRegisteredEvents();
    events.forEach((_, events) {
      for (Map<String, dynamic> event in events) {
        event['mineralEvent']
          ..client = client
          ..stores = ioc.singleton(Service.store)
          ..environment = ioc.singleton(Service.environment);
      }
    });
  }

  void infuseClientIntoCommands ({required CommandManager manager, required MineralClient client}) {
    Map<String, dynamic> commands = manager.getHandlers();
    commands.forEach((_, handler) {
      handler['commandClass']
        ..client = client
        ..stores = ioc.singleton(Service.store)
        ..environment = ioc.singleton(Service.environment);
    });
  }
}
