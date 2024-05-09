import 'dart:async';
import 'package:mineral/api/server/managers/sticker_manager.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerStickersUpdateEventHandler = FutureOr<void> Function(StickerManager, Server);

abstract class ServerStickersUpdateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverStickersUpdate;

  FutureOr<void> handle(StickerManager stickerManager, Server server);
}
