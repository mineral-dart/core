import 'dart:async';

import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerPresenceUpdateEventHandler = FutureOr<void> Function(Member, Server, Presence);

abstract class ServerPresenceUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverPresenceUpdate;

  @override
  String? customId;

  FutureOr<void> handle(Member member, Server server, Presence presence);
}
