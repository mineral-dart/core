import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivatePollVoteAddEventHandler = FutureOr<void> Function(
    PrivateMessage, Member, int);

abstract class PrivatePollVoteAddEvent implements ListenableEvent {
  @override
  Event get event => Event.privatePollVoteAdd;

  @override
  String? customId;

  FutureOr<void> handle(PrivateMessage message, User user, int answer);
}
