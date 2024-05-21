import 'dart:async';

import 'package:mineral/api/common/reaction_emoji.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMessageReactionRemoveEventHandler = FutureOr<void> Function(ServerMessage, ReactionEmoji<ServerChannel>, Server, Member);

abstract class ServerMessageReactionRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageReactionRemove;

  FutureOr<void> handle(ServerMessage message, ReactionEmoji<ServerChannel> reaction, Server server, Member member);
}
