import 'dart:async';

import 'package:mineral/src/api/server/invite.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef InviteCreateEventHandler = FutureOr<void> Function(Invite invite);

abstract class InviteCreateEvent implements ListenableEvent {
  @override
  Event get event => Event.inviteCreate;

  @override
  String? customId;

  FutureOr<void> handle(Invite invite);
}
