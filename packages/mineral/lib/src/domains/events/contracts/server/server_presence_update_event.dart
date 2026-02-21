import 'dart:async';

import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerPresenceUpdateEventHandler = FutureOr<void> Function(Member, Presence);

abstract class ServerPresenceUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverPresenceUpdate;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Member member, Presence presence);
}
