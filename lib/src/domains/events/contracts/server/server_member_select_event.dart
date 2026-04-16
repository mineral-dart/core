import 'dart:async';

import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMemberSelectEventHandler = FutureOr Function(
    ServerSelectContext, List<Member>);

abstract class ServerMemberSelectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMemberSelect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerSelectContext ctx, List<Member> members);
}
