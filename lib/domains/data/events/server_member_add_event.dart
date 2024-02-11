import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerMemberAddEventHandler = FutureOr<void> Function(Member, Server);

abstract class ServerMemberAddEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverMemberAdd;

  FutureOr<void> handle(Member member, Server server);
}
