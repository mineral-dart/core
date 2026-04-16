import 'dart:async';

import 'package:mineral/src/api/server/managers/emoji_manager.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerEmojisUpdateEventHandler = FutureOr<void> Function(
    EmojiManager, Server);

abstract class ServerEmojisUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverEmojisUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(EmojiManager emojisManager, Server server);
}
