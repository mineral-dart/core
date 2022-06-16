import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/command_manager.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class Ready implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.ready;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    CommandManager commandManager = ioc.singleton(Service.command);

    MineralClient client = MineralClient.from(payload: websocketResponse.payload);
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

    eventManager.emit(Events.ready, [client]);
  }

  void infuseClientIntoEvents ({ required EventManager manager, required MineralClient client }) {
    Collection<Events, List<MineralEvent>> events = manager.getRegisteredEvents();
    events.forEach((_, events) {
      for (MineralEvent event in events) {
        event.client = client;
        event.stores = ioc.singleton(Service.store);
      }
    });
  }

  void infuseClientIntoCommands ({ required CommandManager manager, required MineralClient client }) {
    Map<String, dynamic> commands = manager.getHandlers();
    commands.forEach((_, handler) {
      MineralCommand command = handler['commandClass'];

      command.client = client;
      command.store = ioc.singleton(Service.store);
    });
  }
}
