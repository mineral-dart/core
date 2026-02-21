import 'dart:async';

import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMemberSelectEventHandler = FutureOr Function(
    ServerSelectContext, List<Member>);

abstract class ServerMemberSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberSelect;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerSelectContext ctx, List<Member> members);
}
