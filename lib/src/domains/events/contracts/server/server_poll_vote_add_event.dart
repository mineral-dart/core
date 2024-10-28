import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerPollVoteAddEventHandler = FutureOr<void> Function(ServerMessage, Member, int);

abstract class ServerPollVoteAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverPollVoteAdd;

  @override
  String? customId;

  FutureOr<void> handle(ServerMessage message, Member member, int answer);
}
