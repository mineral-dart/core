import 'dart:async';

import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/domains/events/event.dart';

typedef PrivateMessageReactionRemoveEmojiEventHandler = FutureOr<void> Function(ServerMessage, Emoji, PrivateChannel);

abstract class PrivateMessageReactionRemoveEmojiEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageReactionRemoveEmoji;

  FutureOr<void> handle(ServerMessage message, Emoji emoji, PrivateChannel channel);
}
