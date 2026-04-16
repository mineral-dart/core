import 'dart:async';

import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerPresenceUpdateEventHandler = FutureOr<void> Function(
    Member, Presence);

abstract class ServerPresenceUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverPresenceUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Member member, Presence presence);
}
