import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/command_manager.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/entities/file_entity.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class Ready implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.ready;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(ioc.services.event);
    CommandManager commandManager = ioc.singleton(ioc.services.command);

    MineralClient client = MineralClient.from(payload: websocketResponse.payload);

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

    eventManager.emit(Events.ready, [client]);
  }

  void infuseClientIntoEvents ({ required EventManager manager, required MineralClient client }) {
    Map<Events, List<FileEntity>> events = manager.events;
    events.forEach((_, events) {
      for (FileEntity eventEntity in events) {
        eventEntity.instanceMirror.reflectee.client = client;
        eventEntity.instanceMirror.reflectee.stores = ioc.singleton(ioc.services.store);
      }
    });
  }

  void infuseClientIntoCommands ({ required CommandManager manager, required MineralClient client }) {
    Map<String, dynamic> commands = manager.handlers;
    commands.forEach((_, handler) {
      InstanceMirror instanceMirror = handler['instanceMirror'];

      instanceMirror.reflectee.client = client;
      instanceMirror.reflectee.stores = ioc.singleton(ioc.services.store);
    });
  }
}
