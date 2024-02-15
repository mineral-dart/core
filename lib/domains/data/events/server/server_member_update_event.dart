import 'dart:async';

import 'package:mineral/api/server/member.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerMemberUpdateEventHandler = FutureOr<void> Function(Member, Member);

abstract class ServerMemberAddEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverMemberUpdate;

  FutureOr<void> handle(Member before, Member after);
}
