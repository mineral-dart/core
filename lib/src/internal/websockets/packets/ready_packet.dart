import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ReadyPacket with Container implements WebsocketPacket {
  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    EventManager eventManager = container.use<EventManager>();
    ShardManager shardManager = container.use<ShardManager>();
    try {
      container.use<MineralClient>();
    } catch (err) {
      MineralClient client = MineralClient.from(payload: websocketResponse.payload);
      client.uptime = DateTime.now();

      // await client.registerGlobalCommands(commands: commandManager.getGlobals());

      final Shard shard = websocketResponse.payload['shard'] != null
        ? shardManager.shards[websocketResponse.payload['shard'][0]]!
        : shardManager.shards[0]!;

      shard.sessionId = websocketResponse.payload['session_id'];
      shard.resumeURL = websocketResponse.payload['resume_gateway_url'];
      shard.initialize();

      eventManager.controller.add(ReadyEvent(container.use<MineralClient>()));
    }
  }
}
