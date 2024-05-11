import 'dart:async';

import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef PrivateMessageReactionRemoveEmojiEventHandler = FutureOr<void> Function(ServerMessage, Emoji, PrivateChannel);

abstract class PrivateMessageReactionRemoveEmojiEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateMessageReactionRemoveEmoji;

  FutureOr<void> handle(ServerMessage message, Emoji emoji, PrivateChannel channel);
}
