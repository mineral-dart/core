import 'dart:async';
import 'package:mineral/api/server/managers/emoji_manager.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerEmojisUpdateEventHandler = FutureOr<void> Function(EmojiManager, Server);

abstract class ServerEmojisUpdateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverEmojisUpdate;

  FutureOr<void> handle(EmojiManager emojisManager, Server server);
}
