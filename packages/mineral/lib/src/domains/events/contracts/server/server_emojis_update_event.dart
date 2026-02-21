import 'dart:async';

import 'package:mineral/src/api/server/managers/emoji_manager.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerEmojisUpdateEventHandler = FutureOr<void> Function(
    EmojiManager, Server);

abstract class ServerEmojisUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverEmojisUpdate;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(EmojiManager emojisManager, Server server);
}
