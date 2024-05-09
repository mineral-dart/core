import 'dart:async';

import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerPresenceUpdateEventHandler = FutureOr<void> Function(Member, Server, Presence);

abstract class ServerUpdateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverPresenceUpdate;

  FutureOr<void> handle(Member member, Server server, Presence presence);
}
