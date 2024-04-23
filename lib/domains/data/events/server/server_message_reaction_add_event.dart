import 'dart:async';

import 'package:mineral/api/common/reaction_emoji.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerMessageReactionAddEventHandler = FutureOr<void> Function(ServerMessage, ReactionEmoji<ServerChannel>, Server, Member);

abstract class ServerMessageReactionAddEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverMessageReactionAdd;

  FutureOr<void> handle(ServerMessage message, ReactionEmoji<ServerChannel> reaction, Server server, Member member);
}
