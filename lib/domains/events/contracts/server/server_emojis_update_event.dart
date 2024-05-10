import 'dart:async';
import 'package:mineral/api/server/managers/emoji_manager.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerEmojisUpdateEventHandler = FutureOr<void> Function(EmojiManager, Server);

abstract class ServerEmojisUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverEmojisUpdate;

  FutureOr<void> handle(EmojiManager emojisManager, Server server);
}
