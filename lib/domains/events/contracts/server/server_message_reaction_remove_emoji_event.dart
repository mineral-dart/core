import 'dart:async';

import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMessageReactionRemoveEmojiEventHandler = FutureOr<void> Function(ServerMessage, Emoji, Server);

abstract class ServerMessageReactionRemoveEmojiEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageReactionRemoveEmoji;

  FutureOr<void> handle(ServerMessage message, Emoji emoji, Server server);
}
