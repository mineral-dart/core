import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerPollVoteAddEventHandler = FutureOr<void> Function(Message, Member, int);

abstract class ServerPollVoteAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverPollVoteAdd;

  @override
  String? customId;

  FutureOr<void> handle(Message message, Member member, int answer);
}
