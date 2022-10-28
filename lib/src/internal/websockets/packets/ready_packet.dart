import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ReadyPacket implements WebsocketPacket {
  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    ShardManager shardManager = ioc.singleton(Service.shards);

    if (ioc.singleton(Service.client) == null) {
      MineralClient client = MineralClient.from(
          payload: websocketResponse.payload);
      client.uptime = DateTime.now();

      ioc.bind(namespace: Service.client, service: client);

      // await client.registerGlobalCommands(commands: commandManager.getGlobals());


      final Shard shard = websocketResponse.payload['shard'] != null
          ? shardManager.shards[websocketResponse.payload['shard'][0]]!
          : shardManager.shards[0]!;

      shard.sessionId = websocketResponse.payload['session_id'];
      shard.resumeURL = websocketResponse.payload['resume_gateway_url'];
      shard.initialize();

      eventManager.controller.add(ReadyEvent(ioc.singleton(Service.client)));
    }
  }
}
