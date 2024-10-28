import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerPollVoteRemoveEventHandler = FutureOr<void> Function(Message, Member, int);

abstract class ServerPollVoteRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.serverPollVoteRemove;

  @override
  String? customId;

  FutureOr<void> handle(Message message, Member member, int answer);
}
